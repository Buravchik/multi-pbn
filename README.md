# Multi-site static hosting with Caddy

This repo deploys hundreds of static sites (HTML/JS/CSS) behind a single Caddy server with automatic HTTPS via Let's Encrypt.

## Features

- Auto HTTPS and renewals for each domain (no certbot needed)
- One folder per domain under `sites/`
- Add a new site with a simple script
- No per-site containers; minimal ops
- Resource limits to prevent server overload
- Enhanced security headers and CSP
- Structured JSON logging with rotation
- Automated backup system
- Hardened container security

## Requirements

- Docker and Docker Compose
- DNS A/AAAA records pointing your domains to the server IP

## Quick start

**Easy way (recommended):**

```bash
./scripts/start.sh
```

This script will:

- Automatically copy `.env.example` to `.env` if missing
- Validate your environment configuration
- Check Caddyfile formatting
- Start the services
- Verify everything is working

**Manual way:**

1. Copy the environment template and set your email:

   ```bash
   cp .env.example .env
   # Edit .env and set CADDY_EMAIL=your-email@example.com
   ```

2. Start the stack:

   ```bash
   docker compose up -d
   ```

3. Add a site (creates `sites/example.com` from template):

   ```bash
   ./scripts/add-site.sh example.com --www
   ```

4. Point DNS for `example.com` (and `www.example.com` if used) to the server, then visit `https://example.com`.

## Layout

```text
.
├── .env.example
├── Caddyfile
├── compose.yml
├── scripts/
│   └── add-site.sh
└── sites/
    ├── _template/
    │   ├── index.html
    │   ├── main.js
    │   └── styles.css
    └── example.com/
        ├── index.html
        ├── main.js
        └── styles.css
```

## How it works

- Caddy serves content from `/srv/sites/{host}`. If a request is for `example.com`, it serves files from `sites/example.com`.
- Certificates are stored in the Docker volume `caddy_data` and are renewed automatically.

## Hardening

This stack runs a hardened single Caddy container:

- Read-only root filesystem
- Drops all Linux capabilities except `NET_BIND_SERVICE`
- `no-new-privileges` enabled
- Runs as non-root user `1000:1000`
- `sites/` is mounted read-only; only `/data` and `/config` are writable volumes for Caddy state
- Tmpfs for `/tmp` and `/run`

If you need file uploads or dynamic writes, use a separate writable volume/path per requirement.

## Per-site tweaks

For most sites, drop static files into the domain folder. If you need special redirects or headers for a specific site, we can extend the config with per-host `handle` blocks.

## Staging certificates (optional)

To avoid Let’s Encrypt rate limits during testing, set the staging CA temporarily by adding this to the `:443` block in `Caddyfile`:

```caddy
tls {
  issuer acme {
    ca https://acme-staging-v02.api.letsencrypt.org/directory
  }
}
```

Then reload Caddy:

```bash
docker compose restart caddy
```

## Backups

Use the automated backup script:

```bash
./scripts/backup.sh
```

This creates a compressed backup of:

- All sites in `sites/` directory
- Caddy configuration files
- SSL certificates and Caddy state
- Docker volumes

Backups are stored in `./backups/` with timestamps.

## Validation

Before starting services, validate your configuration:

```bash
./scripts/validate.sh
```

**Run validation when:**

- Before starting services (`docker compose up -d`)
- After editing `.env` or `Caddyfile`
- After making configuration changes
- When troubleshooting issues
- For regular health checks

**The validator checks:**

- ✅ `.env` file exists and `CADDY_EMAIL` is set
- ✅ Caddyfile syntax and formatting
- ✅ Docker is running
- ✅ All configuration is valid

## Performance Optimization

### UDP Buffer Sizes (HTTP/3)

If you see UDP buffer warnings in the logs, optimize them for better HTTP/3 performance:

```bash
sudo ./scripts/fix-udp-buffers.sh
```

This script:
- Sets optimal UDP buffer sizes for HTTP/3 (QUIC)
- Makes changes persistent across reboots
- Improves performance for high-traffic sites

**Note:** The warning doesn't break functionality, but fixing it improves performance.

## Troubleshooting

- Ensure ports 80 and 443 are open to the internet.
- DNS must resolve to this server before TLS issuance succeeds.
- **First, run validation:** `./scripts/validate.sh`
- **For UDP buffer warnings:** `sudo ./scripts/fix-udp-buffers.sh`
- Check logs:

  ```bash
  docker compose logs -f caddy | cat
  ```
