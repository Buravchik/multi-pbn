#!/bin/sh

set -eu

# Requirements: CF_API_TOKEN and CF_ZONE_ID in environment or .env
# Usage: ./scripts/cf-set-dns.sh sub.domain.tld [--proxied|--dns-only] [--ip <IP>]

if [ $# -lt 1 ]; then
  echo "Usage: $0 <fqdn> [--proxied|--dns-only] [--ip <IP>]" >&2
  exit 1
fi

FQDN="$1"
shift || true

PROXIED=true
IP_OVERRIDE=""

while [ $# -gt 0 ]; do
  case "$1" in
    --proxied)
      PROXIED=true
      ;;
    --dns-only)
      PROXIED=false
      ;;
    --ip)
      shift
      IP_OVERRIDE="${1-}"
      ;;
  esac
  shift || true
done

# Load .env if present
if [ -f .env ]; then
  # shellcheck disable=SC2046
  export $(grep -E '^(CF_API_TOKEN|CF_ZONE_ID)=' .env | xargs) || true
fi

# Require token
if [ -z "${CF_API_TOKEN-}" ]; then
  echo "Missing CF_API_TOKEN. Set it in environment or .env" >&2
  exit 1
fi

# Determine IP
if [ -n "$IP_OVERRIDE" ]; then
  ORIGIN_IP="$IP_OVERRIDE"
else
  ORIGIN_IP="$(curl -fsS https://api.ipify.org || curl -fsS https://ifconfig.me)"
fi

if [ -z "$ORIGIN_IP" ]; then
  echo "Failed to detect public IP; pass --ip <IP>" >&2
  exit 1
fi

API="https://api.cloudflare.com/client/v4"

# Determine Zone ID from domain if not provided
if [ -z "${CF_ZONE_ID-}" ]; then
  BASE_DOMAIN="${FQDN#*.}"
  # For multi-level subdomains, reduce to zone by querying CF
  ZRESP=$(curl -fsS -H "Authorization: Bearer $CF_API_TOKEN" -H "Content-Type: application/json" "$API/zones?name=$BASE_DOMAIN")
  CF_ZONE_ID=$(printf '%s' "$ZRESP" | sed -n 's/.*"result":\[{"id":"\([a-f0-9]\{32\}\)".*/\1/p') || true
  if [ -z "${CF_ZONE_ID-}" ]; then
    echo "Unable to determine CF_ZONE_ID for $BASE_DOMAIN" >&2
    exit 1
  fi
fi

# Find existing record
REC_ID=$(curl -fsS -X GET -H "Authorization: Bearer $CF_API_TOKEN" -H "Content-Type: application/json" "$API/zones/$CF_ZONE_ID/dns_records?type=A&name=$FQDN" | sed -n 's/.*"id":"\([a-f0-9]\{32\}\)".*/\1/p' | head -n1 || true)

BODY=$(printf '{"type":"A","name":"%s","content":"%s","ttl":120,"proxied":%s}' "$FQDN" "$ORIGIN_IP" "$PROXIED")

if [ -n "$REC_ID" ]; then
  echo "Updating A record for $FQDN -> $ORIGIN_IP (proxied=$PROXIED)"
  curl -fsS -X PUT -H "Authorization: Bearer $CF_API_TOKEN" -H "Content-Type: application/json" -d "$BODY" "$API/zones/$CF_ZONE_ID/dns_records/$REC_ID" >/dev/null
else
  echo "Creating A record for $FQDN -> $ORIGIN_IP (proxied=$PROXIED)"
  curl -fsS -X POST -H "Authorization: Bearer $CF_API_TOKEN" -H "Content-Type: application/json" -d "$BODY" "$API/zones/$CF_ZONE_ID/dns_records" >/dev/null
fi

echo "Done. Propagation may take a minute."


