#!/bin/bash

echo "🔍 Validating Multi-Site Hosting Setup..."
echo ""

# Check .env file
echo "📄 Checking environment configuration..."
if [ ! -f .env ]; then
    echo "❌ No .env file found!"
    echo "   Run: ./scripts/start.sh"
    exit 1
fi

# Check CADDY_EMAIL
if ! grep -q "CADDY_EMAIL=" .env || grep -q "CADDY_EMAIL=you@example.com" .env; then
    echo "❌ CADDY_EMAIL not properly configured!"
    echo "   Edit .env and set: CADDY_EMAIL=your-actual-email@example.com"
    exit 1
fi

# Check METRICS_SECRET
if ! grep -q "METRICS_SECRET=" .env || grep -q "METRICS_SECRET=change-this-secret-key-here" .env; then
    echo "❌ METRICS_SECRET not properly configured!"
    echo "   Edit .env and set: METRICS_SECRET=your-secure-random-secret-key"
    echo "   Generate one with: openssl rand -base64 32"
    exit 1
fi

# Validate Caddyfile
echo "🔍 Validating Caddyfile..."
if ! ./scripts/format-caddyfile.sh > /dev/null 2>&1; then
    echo "❌ Caddyfile validation failed!"
    exit 1
fi

# Check Docker
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running!"
    exit 1
fi

echo "✅ All validations passed!"
echo "   ✅ Environment variables configured"
echo "   ✅ Caddyfile syntax valid"
echo "   ✅ Docker is running"
echo "   Ready to start with: docker compose up -d"
