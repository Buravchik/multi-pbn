#!/bin/bash

echo "🔧 Fixing UDP buffer sizes for HTTP/3..."

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "❌ This script needs to be run as root (use sudo)"
    echo "   Run: sudo ./scripts/fix-udp-buffers.sh"
    exit 1
fi

# Set optimal UDP buffer sizes
echo "Setting UDP buffer sizes..."
sysctl -w net.core.rmem_max=16777216
sysctl -w net.core.rmem_default=26214400
sysctl -w net.core.wmem_max=16777216
sysctl -w net.core.wmem_default=26214400

# Make changes persistent
echo "Making changes persistent..."
cat >> /etc/sysctl.conf << EOF

# HTTP/3 (QUIC) UDP buffer optimization
net.core.rmem_max = 16777216
net.core.rmem_default = 26214400
net.core.wmem_max = 16777216
net.core.wmem_default = 26214400
EOF

echo "✅ UDP buffer sizes optimized!"
echo "   Changes will persist after reboot"
echo "   Restart Caddy to apply: docker compose restart caddy"
