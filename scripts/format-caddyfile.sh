#!/bin/bash

echo "Formatting Caddyfile with Caddy's formatter..."

# Run Caddy fmt to check and fix formatting
docker run --rm \
  -v "$(pwd)/Caddyfile:/etc/caddy/Caddyfile" \
  caddy:2-alpine \
  caddy fmt --overwrite /etc/caddy/Caddyfile

echo "Caddyfile formatting complete!"
echo "Checking configuration validation..."

# Check for configuration issues (including missing env vars)
if [ -f .env ]; then
  echo "Using .env file for validation..."
  docker run --rm \
    --env-file .env \
    -v "$(pwd)/Caddyfile:/etc/caddy/Caddyfile" \
    caddy:2-alpine \
    caddy validate --config /etc/caddy/Caddyfile
else
  echo "⚠️  No .env file found. Creating temporary .env for validation..."
  echo "CADDY_EMAIL=test@example.com" > .env.tmp
  docker run --rm \
    --env-file .env.tmp \
    -v "$(pwd)/Caddyfile:/etc/caddy/Caddyfile" \
    caddy:2-alpine \
    caddy validate --config /etc/caddy/Caddyfile
  rm .env.tmp
fi

echo "Validation complete!"
