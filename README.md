```
 ______     __     ______     ______
/\  ___\   /\ \   /\  ___\   /\  ___\
\ \___  \  \ \ \  \ \ \__ \  \ \___  \
 \/\_____\  \ \_\  \ \_____\  \/\_____\
  \/_____/   \/_/   \/_____/   \/_____/

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

╔══════════════════════════════════════════════════════════╗
║  ▓▓▓▓▓▓▓  ▓▓▓▓▓▓▓    ▓▓▓▓▓▓   ▓▓▓▓▓▓▓                   ║
║  ▓▓       ▓▓   ▓▓   ▓▓        ▓▓   ▓▓                   ║
║  ▓▓▓▓▓    ▓▓▓▓▓▓▓  ▓▓  ▓▓▓▓  ▓▓   ▓▓   [MINING POOL]   ║
║  ▓▓       ▓▓  ▓▓    ▓▓    ▓▓  ▓▓   ▓▓                   ║
║  ▓▓▓▓▓▓▓  ▓▓   ▓▓    ▓▓▓▓▓▓   ▓▓▓▓▓▓▓   >>>ONLINE<<<    ║
╚══════════════════════════════════════════════════════════╝
    [ BLOCKCHAIN MINING // PROOF-OF-WORK // ERGO ]
```

# SIGS MEGA CORE - Mining Pool Operations Hub

**SIGS MEGA CORE** - A comprehensive, production-ready hub for deploying and managing an Ergo cryptocurrency mining pool with supporting services for the Sigmanaut community.

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

This repository serves as the **central orchestration hub** for the SIGS mining pool infrastructure. It brings together multiple components to provide:

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

# 4. Configure Telegram bot (REQUIRED for notifications)
# - Get bot token from @BotFather on Telegram
# - Get chat ID from bot API
# - See "Telegram Bot Configuration" section below for details
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

### Telegram Bot Configuration

The Nurse Shark Bot requires Telegram API credentials. Edit `Nurse-Shark-Bot/config.yaml`:

#### Step 1: Create a Telegram Bot

1. Message [@BotFather](https://t.me/BotFather) on Telegram
2. Send `/newbot` command
3. Follow prompts to name your bot
4. Copy the **bot token** (looks like `123456789:ABCdefGHIjklMNOpqrsTUVwxyz`)

#### Step 2: Get Chat IDs

**For a regular chat/group:**
1. Add your bot to the group
2. Send a test message in the group
3. Visit: `https://api.telegram.org/bot<YOUR_BOT_TOKEN>/getUpdates`
4. Find `"chat":{"id":-1001234567890}` in the JSON response

**For a forum/topic channel:**
- The `topic_id` is the message thread ID visible in the URL

#### Step 3: Configure the Bot

```yaml
# Nurse-Shark-Bot/config.yaml

# Ergo blockchain explorer
explorer:
  url: "https://api.ergoplatform.com/api/v1"
  max_retries: 5
  retry_delay: 3.0

# Telegram bot credentials
telegram:
  bot_token: "123456789:ABCdefGHIjklMNOpqrsTUVwxyz"  # From @BotFather
  default_chat_id: "-1001234567890"  # Main notification chat
  default_topic_id: null  # Optional: specific forum topic

# Addresses to monitor (pool wallet, payout wallet, etc.)
addresses:
  - address: "9g1p6UU8XoAeU4yGPLpbTHYiG8aBHKfNFZbL8VaNLJZ3vN3jVyP"
    nickname: "Pool Hot Wallet"
    telegram_destinations:
      - chat_id: "-1001234567890"
        topic_id: null

  - address: "9fN8S6DqVXKm7tPPqF4xH2DLjG8D5TPBL4bKuNm8FxZp2VwNQsX"
    nickname: "Pool Payout Wallet"
    telegram_destinations:
      - chat_id: "-1001234567890"
        topic_id: 1  # If using forum topics
```

#### What the Bot Monitors

- Incoming transactions to pool wallets
- Outgoing payouts to miners
- Balance changes
- Transaction confirmations
- Unusual activity alerts

**Note:** You can disable the bot by setting `nurse-shark-bot: false` in `conf/conf.yaml`

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

#### Telegram bot not working

```bash
# Check bot logs
docker-compose logs nurse-shark-bot

# Verify bot token is correct
# Test bot manually: https://api.telegram.org/bot<YOUR_TOKEN>/getMe

# Common issues:
# 1. Bot token invalid or expired
#    - Create new bot with @BotFather if needed
# 2. Bot not added to chat/group
#    - Add bot to your Telegram group with admin rights
# 3. Incorrect chat ID
#    - Get updates: https://api.telegram.org/bot<YOUR_TOKEN>/getUpdates
#    - Send message in group first, then check updates
# 4. Missing addresses to monitor
#    - Add wallet addresses in config.yaml
# 5. Explorer API issues
#    - Check if https://api.ergoplatform.com/api/v1 is accessible

# To disable bot temporarily
# Set nurse-shark-bot: false in conf/conf.yaml
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
