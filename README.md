```
 ______     __     ______     __    __     ______     __   __     ______     __  __     ______
/\  ___\   /\ \   /\  ___\   /\ "-./  \   /\  __ \   /\ "-.\ \   /\  __ \   /\ \/\ \   /\__  _\
\ \___  \  \ \ \  \ \ \__ \  \ \ \-./\ \  \ \  __ \  \ \ \-.  \  \ \  __ \  \ \ \_\ \  \/_/\ \/
 \/\_____\  \ \_\  \ \_____\  \ \_\ \ \_\  \ \_\ \_\  \ \_\\"\_\  \ \_\ \_\  \ \_____\    \ \_\
  \/_____/   \/_/   \/_____/   \/_/  \/_/   \/_/\/_/   \/_/ \/_/   \/_/\/_/   \/_____/     \/_/

 __    __     ______     ______     ______
/\ "-./  \   /\  ___\   /\  ___\   /\  __ \
\ \ \-./\ \  \ \  __\   \ \ \__ \  \ \  __ \
 \ \_\ \ \_\  \ \_____\  \ \_____\  \ \_\ \_\
  \/_/  \/_/   \/_____/   \/_____/   \/_/\/_/

 ______     ______     ______     ______
/\  ___\   /\  __ \   /\  == \   /\  ___\
\ \ \____  \ \ \/\ \  \ \  __<   \ \  __\
 \ \_____\  \ \_____\  \ \_\ \_\  \ \_____\
  \/_____/   \/_____/   \/_/ /_/   \/_____/
```

# Sigmanaut Mining Pool - Operations Hub

**Ergo Mining Pool Operations Core** - A comprehensive, production-ready hub for deploying and managing an Ergo cryptocurrency mining pool with supporting services.

## 📋 Table of Contents

1. [Overview](#overview)
2. [Architecture](#architecture)
3. [Components](#components)
4. [Quick Start](#quick-start)
5. [Deployment Options](#deployment-options)
6. [Configuration](#configuration)
7. [Docker Images](#docker-images)
8. [Monitoring & Logs](#monitoring--logs)
9. [Troubleshooting](#troubleshooting)
10. [Contributing](#contributing)
11. [License](#license)

---

## 🎯 Overview

This repository serves as the **central orchestration hub** for the Sigmanaut Mining Pool infrastructure. It brings together multiple components to provide:

- **Ergo Mining Pool**: Full-featured mining pool software based on [Miningcore](https://github.com/marctheshark3/ergo-miningcore)
- **Custom API**: RESTful API for pool statistics via [Mining Wave](https://github.com/marctheshark3/mining-wave)
- **Telegram Bot**: Automated notifications for pool events via [Nurse Shark Bot](https://github.com/The-Last-Byte-Bar/Nurse-Shark-Bot)
- **Flexible Deployment**: Single-server or split deployment for optimal performance

---

## 🏗️ Architecture

### All-in-One Deployment
```
┌─────────────────────────────────────────┐
│          Single Server                  │
│  ┌─────────────────────────────────┐   │
│  │  Ergo Miningcore (Pool)         │   │
│  │  PostgreSQL + Redis             │   │
│  │  Mining Wave API                │   │
│  │  Nurse Shark Bot                │   │
│  │  Nginx Reverse Proxy            │   │
│  └─────────────────────────────────┘   │
└─────────────────────────────────────────┘
```

### Split Deployment (Recommended for Production)
```
┌──────────────────────────┐        ┌────────────────────────┐
│   Pool Server            │        │   Services Server      │
│   (Performance Critical) │───────▶│   (Dashboards/Bots)    │
│                          │  TCP   │                        │
│  ┌────────────────────┐ │  5432  │  ┌──────────────────┐ │
│  │ Ergo Miningcore    │ │        │  │ Mining Wave API  │ │
│  │ PostgreSQL         │ │        │  │ Nurse Shark Bot  │ │
│  │ Redis              │ │        │  │ Nginx Proxy      │ │
│  │ Nginx (minimal)    │ │        │  └──────────────────┘ │
│  └────────────────────┘ │        │                        │
│                          │        │                        │
│  Ports: 4444,5555,7777  │        │  Ports: 80,443,8000   │
└──────────────────────────┘        └────────────────────────┘
```

---

## 🧩 Components

### Core Services

| Component | Purpose | Repository |
|-----------|---------|------------|
| **Ergo Miningcore** | Mining pool software with Stratum support | [ergo-miningcore](https://github.com/marctheshark3/ergo-miningcore) |
| **Mining Wave** | Custom API for pool statistics and data | [mining-wave](https://github.com/marctheshark3/mining-wave) |
| **Nurse Shark Bot** | Telegram bot for notifications and monitoring | [Nurse-Shark-Bot](https://github.com/The-Last-Byte-Bar/Nurse-Shark-Bot) |

### Infrastructure

- **PostgreSQL 15**: Pool data storage with replication support
- **Redis 7**: High-performance caching layer
- **Nginx**: Reverse proxy and load balancer

---

## 🚀 Quick Start

### Prerequisites

- **Docker** 20.10+ and **Docker Compose** 2.0+
- **Git** for cloning and submodule management
- **Python 3.7+** (for startup script)
- **Minimum 4GB RAM** (8GB+ recommended for production)

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/marctheshark3/sigs-mega-core.git
cd sigs-mega-core

# 2. Run setup script (initializes submodules and creates config files)
./setup.sh

# 3. Configure your environment
nano .env

# 4. Configure Telegram bot (if using Nurse Shark Bot)
nano Nurse-Shark-Bot/config.yaml

# 5. Configure pool settings
nano ergo-miningcore/config/ergo-public-pool.json

# 6. Start all services
./start-all.sh
```

That's it! Your mining pool should now be running.

---

## 📦 Deployment Options

### Option 1: All-in-One (Single Server)

Best for: Testing, small pools, or cost-conscious deployments

```bash
./start-all.sh
```

**Access URLs:**
- Mining (Stratum): `stratum+tcp://localhost:4444`
- Pool API: `http://localhost:4000/api/pools`
- Mining Wave API: `http://localhost:8000`

---

### Option 2: Split Deployment (Two Servers)

Best for: Production pools with high traffic

#### Pool Server (Server 1)
```bash
# Edit .env and set DEPLOYMENT_MODE=pool-only
./start-pool.sh
```

**Exposed Services:**
- Stratum mining ports: 4444, 5555, 7777, 8888
- PostgreSQL: 5432 (for remote access)
- Pool API: 4000

#### Services Server (Server 2)
```bash
# Edit .env and set:
#   DEPLOYMENT_MODE=services-only
#   POOL_SERVER_IP=<pool-server-ip>
./start-services.sh
```

**Exposed Services:**
- Mining Wave API: 8000
- Nginx: 80, 443

---

## ⚙️ Configuration

### Environment Variables (.env)

```bash
# Deployment Mode
DEPLOYMENT_MODE=all-in-one  # Options: all-in-one, pool-only, services-only

# Database
POSTGRES_DB=miningcore
POSTGRES_USER=miningcore
POSTGRES_PASSWORD=changeme123

# Ergo Node Connection
ERGO_NODE_HOST=host.docker.internal
ERGO_NODE_PORT=9053

# Mining Ports
STRATUM_PORT_1=4444
STRATUM_PORT_2=5555
STRATUM_SSL_PORT_1=7777
STRATUM_SSL_PORT_2=8888

# For split deployment
POOL_SERVER_IP=  # IP of pool server (for services-only mode)
```

### Service Control (conf/conf.yaml)

Enable or disable individual services:

```yaml
services:
  postgres: true           # PostgreSQL database
  redis: true             # Redis cache
  miningcore: true        # Mining pool
  mining-wave-api: true   # Custom API
  nurse-shark-bot: true   # Telegram bot
  nginx: true             # Reverse proxy
```

### Pool Configuration

Edit `ergo-miningcore/config/ergo-public-pool.json` for:
- Pool wallet address
- Fee percentages
- Minimum payout thresholds
- Vardiff settings
- Pool branding

---

## 🐳 Docker Images

### Pre-built Images

Images are automatically built via GitHub Actions and published to GitHub Container Registry:

```bash
ghcr.io/marctheshark3/ergo-miningcore:latest
ghcr.io/marctheshark3/mining-wave:latest
ghcr.io/the-last-byte-bar/nurse-shark-bot:latest
```

### Local Builds

To build images locally instead of pulling from registry:

```bash
# Remove image references from .env
MININGCORE_IMAGE=
MINING_WAVE_IMAGE=
NURSE_SHARK_BOT_IMAGE=

# Compose will build from local Dockerfiles
docker-compose build
```

---

## 📊 Monitoring & Logs

### View Service Status

```bash
# All-in-one deployment
docker-compose ps

# Pool-only deployment
docker-compose -f docker-compose.pool.yml ps

# Services-only deployment
docker-compose -f docker-compose.services.yml ps
```

### View Logs

```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f miningcore
docker-compose logs -f mining-wave-api

# Last 100 lines
docker-compose logs --tail=100
```

### Health Checks

All services include Docker health checks. Check status:

```bash
docker ps --format "table {{.Names}}\t{{.Status}}"
```

---

## 🔧 Troubleshooting

### Common Issues

#### Services won't start

```bash
# Check Docker is running
docker info

# Check logs for errors
docker-compose logs

# Verify .env file exists
ls -la .env

# Reinitialize submodules
git submodule update --init --recursive
```

#### Database connection errors (split deployment)

```bash
# On services server, test connection to pool server
nc -zv <pool-server-ip> 5432

# Check firewall allows PostgreSQL port
# Check POOL_SERVER_IP in .env is correct
```

#### Pool not accepting connections

```bash
# Verify Ergo node is accessible
curl http://<ergo-node-ip>:9053

# Check miningcore logs
docker-compose logs miningcore

# Verify pool config
cat ergo-miningcore/config/ergo-public-pool.json
```

### Reset Everything

```bash
# Stop all services
docker-compose down

# Remove volumes (WARNING: Deletes all data)
docker-compose down -v

# Clean rebuild
./setup.sh
./start-all.sh
```

---

## 📁 Directory Structure

```
sigs-mega-core/
├── .github/
│   └── workflows/           # GitHub Actions for Docker builds
├── conf/
│   ├── conf.yaml           # Service enable/disable configuration
│   ├── nginx.conf          # Nginx reverse proxy configuration
│   ├── postgresql.conf     # PostgreSQL configuration
│   └── miner_settings.sql  # Database schema
├── ergo-miningcore/        # Submodule: Mining pool software
├── mining-wave/            # Submodule: Custom API
├── Nurse-Shark-Bot/        # Submodule: Telegram bot
├── logs/                   # Service logs
├── ssl/                    # SSL certificates
├── docker-compose.yml      # All-in-one deployment
├── docker-compose.pool.yml # Pool-only deployment
├── docker-compose.services.yml # Services-only deployment
├── setup.sh               # Setup script
├── start-all.sh           # Start all services
├── start-pool.sh          # Start pool server
├── start-services.sh      # Start services server
├── start.py               # Python startup script
├── sample.env             # Environment template
└── README.md              # This file
```

---

## 🤝 Contributing

We welcome contributions! Here's how:

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit changes: `git commit -m 'Add amazing feature'`
4. Push to branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

### Updating Submodules

When updating submodule references:

```bash
cd ergo-miningcore  # or other submodule
git checkout main
git pull
cd ..
git add ergo-miningcore
git commit -m "Update ergo-miningcore submodule"
```

---

## 📜 License

This project is licensed under the **Apache License 2.0** - see the [LICENSE](LICENSE) file for details.

---

## 🆘 Support

- **Issues**: [GitHub Issues](https://github.com/marctheshark3/sigs-mega-core/issues)
- **Discussions**: [GitHub Discussions](https://github.com/marctheshark3/sigs-mega-core/discussions)
- **Ergo Community**: [Ergo Discord](https://discord.gg/ergo)

---

## 🙏 Acknowledgments

- [Miningcore](https://github.com/oliverw/miningcore) - Original mining pool software
- [Ergo Platform](https://ergoplatform.org/) - The blockchain this pool supports
- Sigmanaut community for testing and feedback

---

**Happy Mining!** ⛏️
