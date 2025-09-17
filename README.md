# Multi-site static hosting with Caddy

This repo deploys hundreds of static sites (HTML/JS/CSS) behind a single Caddy server with automatic HTTPS via Let's Encrypt.

## Features

- Auto HTTPS and renewals for each domain (no certbot needed)
- One folder per domain under `sites/`
- Add a new site with a simple script
- No per-site containers; minimal ops

## Requirements

- Docker and Docker Compose
- DNS A/AAAA records pointing your domains to the server IP

## Quick start

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

```
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

- Backup `sites/` (your content) and the `caddy_data` volume (certificate state).

## Troubleshooting

- Ensure ports 80 and 443 are open to the internet.
- DNS must resolve to this server before TLS issuance succeeds.
- Check logs:

  ```bash
  docker compose logs -f caddy | cat
  ```


