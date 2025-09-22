from flask import Flask, request, jsonify
import os
import time
import hashlib
import hmac
from prometheus_client import Counter, Histogram, generate_latest, CONTENT_TYPE_LATEST

app = Flask(__name__)

SITES_ROOT = os.environ.get("SITES_ROOT", "/srv/sites")
METRICS_SECRET = os.environ.get("METRICS_SECRET", "change-this-secret-key")

# Prometheus metrics
REQUEST_COUNT = Counter('ask_requests_total', 'Total requests', ['method', 'endpoint', 'status'])
REQUEST_DURATION = Histogram('ask_request_duration_seconds', 'Request duration', ['method', 'endpoint'])
DOMAIN_APPROVALS = Counter('ask_domain_approvals_total', 'Domain approval requests', ['domain', 'decision'])

@app.before_request
def before_request():
    request.start_time = time.time()

@app.after_request
def after_request(response):
    duration = time.time() - request.start_time
    REQUEST_DURATION.labels(method=request.method, endpoint=request.endpoint).observe(duration)
    REQUEST_COUNT.labels(method=request.method, endpoint=request.endpoint, status=response.status_code).inc()
    return response

@app.get("/health")
def health():
    return "ok", 200

def verify_metrics_auth():
    """Verify authentication for metrics endpoint"""
    auth_header = request.headers.get('Authorization', '')
    if not auth_header.startswith('Bearer '):
        return False
    
    token = auth_header[7:]  # Remove 'Bearer ' prefix
    expected_token = hashlib.sha256(METRICS_SECRET.encode()).hexdigest()
    
    return hmac.compare_digest(token, expected_token)

@app.get("/metrics")
def metrics():
    # Require authentication for metrics endpoint
    if not verify_metrics_auth():
        return jsonify({"error": "Unauthorized"}), 401
    
    return generate_latest(), 200, {'Content-Type': CONTENT_TYPE_LATEST}

@app.route("/allow", methods=["GET", "POST"])
def allow():
    # Handle both GET (with ?domain=) and POST (with JSON body)
    if request.method == "POST":
        data = request.get_json(silent=True) or {}
        domain = data.get("identifier")
    else:
        domain = request.args.get("domain")
    
    if not domain:
        return jsonify({"error": "missing domain"}), 400

    # Approve only if directory exists for that domain
    site_path = os.path.join(SITES_ROOT, domain)
    if os.path.isdir(site_path):
        DOMAIN_APPROVALS.labels(domain=domain, decision="approved").inc()
        return "ok", 200
    else:
        DOMAIN_APPROVALS.labels(domain=domain, decision="denied").inc()
        return "deny", 403

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)


