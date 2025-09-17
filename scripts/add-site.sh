#!/bin/sh

set -eu

if [ $# -lt 1 ]; then
  echo "Usage: $0 domain.com [--www]" >&2
  exit 1
fi

DOMAIN="$1"
WITH_WWW=false
if [ "${2-}" = "--www" ]; then
  WITH_WWW=true
fi

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
SITES_DIR="$ROOT_DIR/sites"
TEMPLATE_DIR="$SITES_DIR/_template"
TARGET_DIR="$SITES_DIR/$DOMAIN"

if [ -e "$TARGET_DIR" ]; then
  echo "Directory already exists: $TARGET_DIR" >&2
  exit 1
fi

mkdir -p "$TARGET_DIR"
sed "s/{{DOMAIN}}/$DOMAIN/g" "$TEMPLATE_DIR/index.html" > "$TARGET_DIR/index.html"
cp "$TEMPLATE_DIR/styles.css" "$TARGET_DIR/styles.css"
cp "$TEMPLATE_DIR/main.js" "$TARGET_DIR/main.js"

if $WITH_WWW; then
  ln -snf "../$DOMAIN" "$SITES_DIR/www.$DOMAIN"
fi

echo "Created site at $TARGET_DIR"
echo "Remember to point DNS A/AAAA records for $DOMAIN to this server."
echo "If the stack is running, visit https://$DOMAIN to trigger certificate issuance."

