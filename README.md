# Multi-site static hosting with Caddy

This repo deploys hundreds of static sites (HTML/JS/CSS) behind a single Caddy server with automatic HTTPS via Let's Encrypt.

## Features

- Auto HTTPS and renewals for each domain (no certbot needed)
- One folder per domain under `sites/`
- Configurationless hosting via on-demand TLS (no per-domain config)
- Add a new site with a simple script
- No per-site containers; minimal ops
- Resource limits to prevent server overload
- Enhanced security headers and CSP
- Structured JSON logging with rotation
- Manual backup script for site content and certificates
- Production-ready container setup

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
- Certificates are issued automatically using on-demand TLS: when the first request for a hostname arrives, Caddy asks the internal `ask` service for approval; if a directory exists for that hostname, issuance is approved and the cert is obtained.
- Certificates are stored in the Docker volume `caddy_data` and are renewed automatically.

## Services

- caddy: Static file serving and automatic HTTPS (on-demand TLS)
- ask: Lightweight approval endpoint that authorizes certificates only when `sites/<domain>/` exists

## Security

This stack runs a production-ready Caddy container with:

- Security headers (HSTS, CSP, X-Frame-Options, etc.)
- Resource limits to prevent resource exhaustion
- Health checks for service monitoring
- `sites/` mounted read-only; only `/data` and `/config` are writable for Caddy state

For additional hardening, you can add container security options to `compose.yml` as needed.

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

Create manual backups using the backup script:

```bash
./scripts/backup.sh
```

This creates a compressed backup of:

- All sites in `sites/` directory
- Caddy configuration files
- SSL certificates and Caddy state
- Docker volumes

Backups are stored in `./backups/` with timestamps.

**Note:** This is a manual backup system. For automated backups, consider setting up a cron job or external backup solution.

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

Certificate not issued for a domain:

- Make sure `sites/<domain>/` exists (e.g., `sites/example.com/index.html`)
- Hit HTTP first to trigger redirect: `curl -I http://<domain>`
- Then HTTPS: `curl -I https://<domain>`
- Check logs: `docker compose logs -f caddy` and `docker compose logs -f ask`
- If using Cloudflare, set SSL/TLS mode to Full (or Full strict) and consider DNS-only (grey cloud) while debugging
