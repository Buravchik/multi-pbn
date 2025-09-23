#!/bin/sh
set -e

# Optional startup fix for volumes owned by root on host
# Enable with SITES_CHOWN_ON_START=true (default: false)

if [ "${SITES_CHOWN_ON_START}" = "true" ]; then
	WEB_UID=$(id -u www-data 2>/dev/null || echo 82)
	WEB_GID=$(id -g www-data 2>/dev/null || echo 82)
	TARGET_DIR=${SITES_DIR:-/srv/sites}

	if [ -d "$TARGET_DIR" ]; then
		echo "[init] Fixing ownership to ${WEB_UID}:${WEB_GID} under ${TARGET_DIR}..."
		chown -R ${WEB_UID}:${WEB_GID} "$TARGET_DIR" || true

		# Ensure common write dirs exist and are writable
		find "$TARGET_DIR" -type d -exec chmod 0775 {} \; || true
		find "$TARGET_DIR" -type f -exec chmod 0664 {} \; || true
	fi
fi

exit 0
