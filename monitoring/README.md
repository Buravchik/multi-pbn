# Monitoring Setup

Simple monitoring for your multi-site server to track RAM usage, visitor traffic, and system health.

## Quick Setup

**One command setup:**
```bash
sudo ./scripts/setup-monitoring-simple.sh
```

This will:
- Start monitoring services
- Configure firewall security
- Show you the Prometheus targets to add

## What You Get

- **System metrics**: RAM, CPU, disk usage
- **Web traffic**: Request rates, response times, errors
- **PHP performance**: Process pool status
- **Application metrics**: Domain approvals, service health

## Prometheus Configuration

After running the setup script, add these targets to your existing Prometheus:

```yaml
scrape_configs:
  - job_name: 'multi-site-node'
    static_configs:
      - targets: ['YOUR_SERVER_IP:9100']
  - job_name: 'multi-site-caddy'
    static_configs:
      - targets: ['YOUR_SERVER_IP:2019']
  - job_name: 'multi-site-php-fpm'
    static_configs:
      - targets: ['YOUR_SERVER_IP:9253']
  - job_name: 'multi-site-ask'
    static_configs:
      - targets: ['YOUR_SERVER_IP:8080']
```

## Key Metrics

- `node_memory_MemAvailable_bytes` - Available RAM
- `caddy_http_requests_total` - HTTP request count
- `caddy_http_request_duration_seconds` - Response times
- `phpfpm_active_processes` - Active PHP processes
- `ask_domain_approvals_total` - Domain approval requests

## Security

The setup script automatically configures firewall rules to:
- Allow access from `grafana.uploadpix.org`
- Block all other public access to monitoring ports

## Files

- `setup-monitoring-simple.sh` - Main setup script
- `prometheus-config.txt` - Prometheus configuration template
- `php-fpm.conf` - PHP-FPM monitoring configuration
- `grafana-dashboard.json` - Optional Grafana dashboard

## Troubleshooting

**Services not starting:**
```bash
docker compose logs node-exporter
docker compose logs php-fpm-exporter
```

**Firewall issues:**
```bash
sudo ufw status
```

**Test metrics:**
```bash
curl http://localhost:9100/metrics
curl http://localhost:2019/metrics
curl http://localhost:9253/metrics
curl http://localhost:8080/metrics
```