#!/bin/bash

# Quick status check for multi-site server

echo "🔍 Multi-Site Server Status"
echo "=========================="
echo ""

# Check Docker services
echo "📊 Docker Services:"
docker compose ps --format "table {{.Name}}\t{{.Status}}\t{{.Ports}}"
echo ""

# Check monitoring endpoints
echo "📈 Monitoring Endpoints:"
if curl -s http://localhost:9100/metrics >/dev/null 2>&1; then
    echo "   ✅ Node exporter (system metrics)"
else
    echo "   ❌ Node exporter"
fi

if curl -s http://localhost:2019/metrics >/dev/null 2>&1; then
    echo "   ✅ Caddy metrics"
else
    echo "   ❌ Caddy metrics"
fi

if curl -s http://localhost:9253/metrics >/dev/null 2>&1; then
    echo "   ✅ PHP-FPM exporter"
else
    echo "   ❌ PHP-FPM exporter"
fi

if curl -s http://localhost:8080/metrics >/dev/null 2>&1; then
    echo "   ✅ Ask service metrics"
else
    echo "   ❌ Ask service metrics"
fi

echo ""

# Check firewall status
if command -v ufw >/dev/null 2>&1; then
    echo "🔒 Firewall Status:"
    sudo ufw status | grep -E "(9100|2019|9253|8080)" || echo "   No monitoring port rules found"
fi

echo ""

# Show server IP
SERVER_IP=$(curl -s ifconfig.me 2>/dev/null || curl -s ipinfo.io/ip 2>/dev/null || echo "Unknown")
echo "🌐 Server IP: $SERVER_IP"

echo ""
echo "📋 Prometheus targets:"
echo "   - $SERVER_IP:9100  # System metrics"
echo "   - $SERVER_IP:2019  # Caddy metrics"
echo "   - $SERVER_IP:9253  # PHP-FPM metrics"
echo "   - $SERVER_IP:8080  # Ask service metrics"
