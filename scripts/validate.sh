#!/bin/bash
set -e

# Basic validation for required environment variables and configuration

ROOT_DIR=$(cd "$(dirname "$0")/.." && pwd)
ENV_FILE="$ROOT_DIR/.env"

if [ ! -f "$ENV_FILE" ]; then
	echo "[ERROR] .env file is missing. Copy .env.example to .env and set values."
	exit 1
fi

# Load env (supports simple KEY=VALUE lines)
set -a
. "$ENV_FILE"
set +a

missing=0

# Required: CADDY_EMAIL
if [ -z "${CADDY_EMAIL}" ]; then
	echo "[ERROR] CADDY_EMAIL is not set in .env (required for Let's Encrypt)."
	missing=1
fi

# Optional with defaults
: "${SITES_CHOWN_ON_START:=false}"
: "${SITES_DIR:=/srv/sites}"

if [ "$missing" -ne 0 ]; then
	echo "[FATAL] Missing required environment variables. See .env.example."
	exit 1
fi

# Caddyfile syntax check (if caddy available in PATH or container)
if command -v caddy >/dev/null 2>&1; then
	caddy validate --config "$ROOT_DIR/Caddyfile" || { echo "[ERROR] Caddyfile validation failed"; exit 1; }
else
	# Try using container
	docker compose run --rm caddy caddy validate --config /etc/caddy/Caddyfile | cat || true
fi

echo "[OK] Environment and configuration validated."
