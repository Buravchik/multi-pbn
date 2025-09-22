#!/bin/bash

# Simple Multi-Site Server Monitoring Setup
# This script sets up monitoring for your existing Grafana server

set -e

echo "🚀 Multi-Site Server Monitoring Setup"
echo "======================================"
echo ""

# Check if Docker is running
if ! docker info >/dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker first."
    exit 1
fi

# Check if running as root for firewall setup
if [ "$EUID" -ne 0 ]; then
    echo "⚠️  Running without sudo. Firewall setup will be skipped."
    echo "   Run 'sudo ./scripts/setup-monitoring-simple.sh' for full setup."
    SKIP_FIREWALL=true
else
    SKIP_FIREWALL=false
fi

echo "📊 Starting monitoring services..."

# Start the monitoring services
docker compose up -d node-exporter php-fpm-exporter

# Wait for services to be ready
echo "⏳ Waiting for services to start..."
sleep 10

# Get server IP
SERVER_IP=$(curl -s ifconfig.me 2>/dev/null || curl -s ipinfo.io/ip 2>/dev/null || echo "YOUR_SERVER_IP")

echo ""
echo "✅ Monitoring services are running!"
echo ""

# Check service status
echo "🔍 Service Status:"
if curl -s http://localhost:9100/metrics >/dev/null 2>&1; then
    echo "   ✅ Node exporter (system metrics)"
else
    echo "   ❌ Node exporter failed"
fi

if curl -s http://localhost:9253/metrics >/dev/null 2>&1; then
    echo "   ✅ PHP-FPM exporter (process metrics)"
else
    echo "   ❌ PHP-FPM exporter failed"
fi

if curl -s http://localhost:2019/metrics >/dev/null 2>&1; then
    echo "   ✅ Caddy metrics (web server)"
else
    echo "   ❌ Caddy metrics not available"
fi

if curl -s http://localhost:8080/metrics >/dev/null 2>&1; then
    echo "   ✅ Ask service metrics (application)"
else
    echo "   ❌ Ask service metrics not available"
fi

echo ""
echo "🌐 Your server IP: $SERVER_IP"
echo ""

# Setup firewall if running as root
if [ "$SKIP_FIREWALL" = false ]; then
    echo "🔒 Setting up firewall security..."
    
    # Resolve Grafana domain
    GRAFANA_DOMAIN="grafana.uploadpix.org"
    GRAFANA_IPS=$(nslookup $GRAFANA_DOMAIN 2>/dev/null | grep "Address:" | grep -v "#53" | awk '{print $2}' | tr '\n' ' ')
    
    if [ -z "$GRAFANA_IPS" ]; then
        GRAFANA_IPS=$(dig +short $GRAFANA_DOMAIN 2>/dev/null | tr '\n' ' ')
    fi
    
    if [ -n "$GRAFANA_IPS" ]; then
        echo "✅ Resolved $GRAFANA_DOMAIN to: $GRAFANA_IPS"
        
        # Configure UFW if available
        if command -v ufw >/dev/null 2>&1; then
            echo "📋 Configuring UFW firewall..."
            
            for GRAFANA_IP in $GRAFANA_IPS; do
                ufw allow from $GRAFANA_IP to any port 9100 comment "Node exporter - $GRAFANA_DOMAIN" 2>/dev/null || true
                ufw allow from $GRAFANA_IP to any port 2019 comment "Caddy metrics - $GRAFANA_DOMAIN" 2>/dev/null || true
                ufw allow from $GRAFANA_IP to any port 9253 comment "PHP-FPM exporter - $GRAFANA_DOMAIN" 2>/dev/null || true
                ufw allow from $GRAFANA_IP to any port 8080 comment "Ask service - $GRAFANA_DOMAIN" 2>/dev/null || true
            done
            
            ufw deny 9100 comment "Block public access to node exporter" 2>/dev/null || true
            ufw deny 2019 comment "Block public access to caddy metrics" 2>/dev/null || true
            ufw deny 9253 comment "Block public access to php-fpm exporter" 2>/dev/null || true
            ufw deny 8080 comment "Block public access to ask service" 2>/dev/null || true
            
            echo "✅ Firewall configured"
        else
            echo "⚠️  UFW not available. Please configure firewall manually."
        fi
    else
        echo "⚠️  Could not resolve $GRAFANA_DOMAIN. Please configure firewall manually."
    fi
fi

echo ""
echo "🎉 Setup Complete!"
echo ""
echo "📋 Add these targets to your Prometheus configuration:"
echo "   - $SERVER_IP:9100  # System metrics (RAM, CPU, disk)"
echo "   - $SERVER_IP:2019  # Caddy web server metrics"
echo "   - $SERVER_IP:9253  # PHP-FPM process metrics"
echo "   - $SERVER_IP:8080  # Ask service metrics"
echo ""
echo "🔧 Next steps:"
echo "   1. Add the targets above to your prometheus.yml"
echo "   2. Restart Prometheus: docker restart prometheus"
echo "   3. Check targets in Prometheus UI: http://your-prometheus:9090/targets"
echo ""
echo "📊 Key metrics you'll get:"
echo "   • RAM usage: node_memory_MemAvailable_bytes"
echo "   • HTTP traffic: caddy_http_requests_total"
echo "   • Response times: caddy_http_request_duration_seconds"
echo "   • PHP processes: phpfpm_active_processes"
echo "   • Domain approvals: ask_domain_approvals_total"
echo ""
if [ "$SKIP_FIREWALL" = true ]; then
    echo "⚠️  Security: Run 'sudo ./scripts/setup-monitoring-simple.sh' to secure ports"
fi
