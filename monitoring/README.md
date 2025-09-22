# 📊 Monitoring Setup

![Prometheus](https://img.shields.io/badge/Prometheus-E6522C?style=for-the-badge&logo=Prometheus&logoColor=white)
![Grafana](https://img.shields.io/badge/Grafana-F2F4F8?style=for-the-badge&logo=grafana&logoColor=orange)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)

## Overview

Production-ready monitoring for your multi-site hosting solution

[🚀 Quick Setup](#-quick-setup) • [📈 Metrics](#-key-metrics) • [🔒 Security](#-security) • [🔧 Troubleshooting](#-troubleshooting)

---

## 🎯 Overview

Simple monitoring for your multi-site server to track **RAM usage**, **visitor traffic**, and **system health** with basic security measures.

## 🚀 Quick Setup

```bash
sudo ./scripts/setup-monitoring-simple.sh
```

### ✅ **What This Does**

| 🎯 **Action** | 📝 **Description** | 🔒 **Security** |
|---------------|-------------------|-----------------|
| 🚀 **Start Services** | Launches monitoring containers | Internal networks only |
| 🛡️ **Configure Security** | Sets up authentication & isolation | Network restrictions |
| 📊 **Show Targets** | Provides Prometheus configuration | Secure access methods |

## 📈 What You Get

| 📊 **Metric Type** | 🎯 **What's Monitored** | 🔧 **Tool** |
|-------------------|-------------------------|-------------|
| 🖥️ **System** | RAM, CPU, disk usage | Node Exporter |
| 🌐 **Web Traffic** | Request rates, response times, errors | Caddy Metrics |
| 🐘 **PHP Performance** | Process pool status, extensions | PHP-FPM Exporter |
| ✅ **Application** | Domain approvals, service health | Ask Service |

---

## ⚙️ Prometheus Configuration

**After running the setup script, add these targets to your existing Prometheus:**

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

---

## 📊 Key Metrics

| 📈 **Metric** | 🎯 **Purpose** | 📍 **Source** |
|---------------|----------------|---------------|
| `node_memory_MemAvailable_bytes` | Available RAM | Node Exporter |
| `caddy_http_requests_total` | HTTP request count | Caddy |
| `caddy_http_request_duration_seconds` | Response times | Caddy |
| `phpfpm_active_processes` | Active PHP processes | PHP-FPM Exporter |
| `ask_domain_approvals_total` | Domain approval requests | Ask Service |

## 🔒 Security

| 🛡️ **Security Feature** | ✅ **Status** | 🎯 **Protection** |
|-------------------------|---------------|------------------|
| 🌐 **Network Isolation** | ✅ Active | Internal networks only |
| 🚫 **External Access** | ✅ Blocked | No direct internet access |
| 🔐 **Authentication** | ✅ Required | All endpoints secured |
| 🐳 **Container Isolation** | ✅ Active | Isolated Docker networks |

### 🔐 **Authentication Required**

#### 🎯 **Caddy Metrics** (Port 2019)

```bash
curl -u metrics_user:monitoring_password_2024 http://localhost:2019/metrics

```

#### 🎯 **Ask Service Metrics** (Port 8080)

```bash
# Generate token from your METRICS_SECRET
TOKEN=$(echo -n "your-secret-key" | sha256sum | cut -d' ' -f1)
curl -H "Authorization: Bearer $TOKEN" http://localhost:8080/metrics

```

### ⚙️ **Configuration**

**Add to your `.env` file:**

```bash
METRICS_SECRET=your-secure-random-secret-key-here
```

> 🛡️ **For complete security documentation, see [SECURITY.md](../SECURITY.md)**

## 📁 Files

| 📄 **File** | 🎯 **Purpose** | 📍 **Location** |
|-------------|----------------|-----------------|
| 🚀 **setup-monitoring-simple.sh** | Main setup script | `scripts/` |
| ⚙️ **prometheus-config.txt** | Prometheus configuration template | `monitoring/` |
| 🐘 **php-fpm.conf** | PHP-FPM monitoring configuration | `monitoring/` |
| 📊 **grafana-dashboard.json** | Optional Grafana dashboard | `monitoring/` |
| 🐳 **php-fpm/Dockerfile** | Custom PHP-FPM with extensions | `php-fpm/` |

---

## 🔧 Troubleshooting

### 🚨 **Common Issues**

| ❌ **Problem** | ✅ **Solution** | 🔧 **Command** |
|----------------|-----------------|----------------|
| 🐳 **Services not starting** | Check container logs | `docker compose logs node-exporter` |
| 🔥 **Firewall issues** | Check firewall status | `sudo ufw status` |
| 🔐 **Authentication failed** | Verify credentials | See authentication section |

### 🧪 **Test Metrics (With Authentication)**

#### 🎯 **Caddy Metrics** (Basic Auth)

```bash
curl -u metrics_user:monitoring_password_2024 http://localhost:2019/metrics

```

#### 🎯 **Ask Service Metrics** (Bearer Token)

```bash
# Generate token
TOKEN=$(echo -n "your-secret-key" | sha256sum | cut -d' ' -f1)

# Test access
curl -H "Authorization: Bearer $TOKEN" http://localhost:8080/metrics
```

> ⚠️ **Note**: Node exporter and PHP-FPM exporter are now internal-only for security.
---

## 🎉 **Monitoring Ready!**

**Your multi-site hosting solution now has enterprise-grade monitoring with security.**

### 📚 **Next Steps**

- 🔧 **Configure Prometheus** - Add targets to your Prometheus server
- 📊 **Setup Grafana** - Import the provided dashboard
- 🛡️ **Review Security** - Ensure all endpoints are properly secured

**🛡️ Security Level: PRODUCTION-READY** • **📊 Monitoring: ACTIVE** • **🔒 Authentication: BASIC**
