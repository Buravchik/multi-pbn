FROM caddy:2-alpine

# Install su-exec for privilege dropping
RUN apk add --no-cache su-exec

# Create caddy user if it doesn't exist
RUN adduser -D -s /bin/sh -u 1000 caddy || true

# Set proper ownership
RUN chown -R 1000:1000 /data /config /var/log/caddy 2>/dev/null || true
