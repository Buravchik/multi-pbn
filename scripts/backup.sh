#!/bin/bash

set -e

# Configuration
BACKUP_DIR="./backups"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_NAME="multi-site-backup-${DATE}"

echo "Creating backup: ${BACKUP_NAME}"

# Create backup directory
mkdir -p "${BACKUP_DIR}/${BACKUP_NAME}"

# Backup sites directory
echo "Backing up sites..."
cp -r ./sites "${BACKUP_DIR}/${BACKUP_NAME}/"

# Backup Caddy configuration
echo "Backing up configuration..."
cp ./Caddyfile "${BACKUP_DIR}/${BACKUP_NAME}/"
cp ./compose.yml "${BACKUP_DIR}/${BACKUP_NAME}/"
cp .env.example "${BACKUP_DIR}/${BACKUP_NAME}/" 2>/dev/null || true

# Backup Docker volumes (certificates and config)
echo "Backing up Caddy volumes..."
docker run --rm \
  -v multi-site-recovered_caddy_data:/data:ro \
  -v multi-site-recovered_caddy_config:/config:ro \
  -v "$(pwd)/${BACKUP_DIR}/${BACKUP_NAME}:/backup" \
  alpine:latest \
  sh -c "cp -r /data /backup/caddy_data && cp -r /config /backup/caddy_config"

# Create compressed archive
echo "Creating compressed archive..."
cd "${BACKUP_DIR}"
tar -czf "${BACKUP_NAME}.tar.gz" "${BACKUP_NAME}"
rm -rf "${BACKUP_NAME}"

echo "Backup completed: ${BACKUP_DIR}/${BACKUP_NAME}.tar.gz"
echo "Backup size: $(du -h "${BACKUP_NAME}.tar.gz" | cut -f1)"
