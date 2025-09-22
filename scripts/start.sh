#!/bin/bash

set -e

echo "🚀 Starting Multi-Site Hosting Setup..."

# Check if .env exists, if not copy from example
if [ ! -f .env ]; then
    echo "⚠️  No .env file found!"
    if [ -f .env.example ]; then
        echo "📋 Copying .env.example to .env..."
        cp .env.example .env
        echo "✅ Created .env file from template"
        echo "⚠️  IMPORTANT: Edit .env and set your CADDY_EMAIL before starting!"
        echo "   Example: CADDY_EMAIL=your-email@example.com"
        echo ""
        read -p "Press Enter after editing .env file, or Ctrl+C to exit..."
    else
        echo "❌ No .env.example found! Creating basic .env..."
        echo "CADDY_EMAIL=you@example.com" > .env
        echo "TZ=UTC" >> .env
        echo "✅ Created basic .env file"
        echo "⚠️  IMPORTANT: Edit .env and set your CADDY_EMAIL before starting!"
        echo "   Example: CADDY_EMAIL=your-email@example.com"
        echo ""
        read -p "Press Enter after editing .env file, or Ctrl+C to exit..."
    fi
fi

# Validate .env file
echo "🔍 Validating environment configuration..."
if ! grep -q "CADDY_EMAIL=" .env || grep -q "CADDY_EMAIL=you@example.com" .env; then
    echo "❌ CADDY_EMAIL not properly configured in .env file!"
    echo "   Please edit .env and set: CADDY_EMAIL=your-actual-email@example.com"
    exit 1
fi

# Check and generate METRICS_SECRET if needed
if ! grep -q "METRICS_SECRET=" .env || grep -q "METRICS_SECRET=change-this-secret-key-here" .env; then
    echo "🔐 METRICS_SECRET not configured, generating secure secret..."
    ./scripts/generate-secret.sh
    echo ""
fi

# Validate Caddyfile
echo "🔍 Validating Caddyfile..."
if ! ./scripts/format-caddyfile.sh > /dev/null 2>&1; then
    echo "❌ Caddyfile validation failed!"
    echo "   Run: ./scripts/format-caddyfile.sh"
    exit 1
fi

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running!"
    echo "   Please start Docker and try again"
    exit 1
fi

# Start the services
echo "🐳 Starting Docker services..."
docker compose up -d

# Wait a moment for services to start
sleep 3

# Check if Caddy is running
if docker compose ps caddy | grep -q "Up"; then
    echo "✅ Caddy is running successfully!"
    echo ""
    echo "🌐 Your multi-site hosting is ready!"
    echo "   - Add sites with: ./scripts/add-site.sh domain.com"
    echo "   - View logs with: docker compose logs -f caddy"
    echo "   - Stop with: docker compose down"
else
    echo "❌ Caddy failed to start!"
    echo "   Check logs with: docker compose logs caddy"
    exit 1
fi
