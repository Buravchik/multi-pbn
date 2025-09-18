from flask import Flask, request, jsonify
import os

app = Flask(__name__)

SITES_ROOT = os.environ.get("SITES_ROOT", "/srv/sites")

@app.get("/health")
def health():
    return "ok", 200

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
        return "ok", 200
    return "deny", 403

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)


