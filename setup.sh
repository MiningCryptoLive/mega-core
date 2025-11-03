#!/usr/bin/env bash
# ===========================================
# Sigmanaut Mining Pool - Setup Script
# ===========================================
# This script initializes the repository and prepares it for deployment

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}"
cat << "EOF"
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
EOF
echo -e "${NC}"

echo -e "${GREEN}"
cat << "EOF"
╔══════════════════════════════════════════════════════════╗
║  ▓▓▓▓▓▓▓  ▓▓▓▓▓▓▓    ▓▓▓▓▓▓   ▓▓▓▓▓▓▓                   ║
║  ▓▓       ▓▓   ▓▓   ▓▓        ▓▓   ▓▓                   ║
║  ▓▓▓▓▓    ▓▓▓▓▓▓▓  ▓▓  ▓▓▓▓  ▓▓   ▓▓   [MINING POOL]   ║
║  ▓▓       ▓▓  ▓▓    ▓▓    ▓▓  ▓▓   ▓▓                   ║
║  ▓▓▓▓▓▓▓  ▓▓   ▓▓    ▓▓▓▓▓▓   ▓▓▓▓▓▓▓   >>>ONLINE<<<    ║
╚══════════════════════════════════════════════════════════╝
    [ BLOCKCHAIN MINING // PROOF-OF-WORK // ERGO ]
EOF
echo -e "${NC}"

echo -e "${GREEN}=== SIGS MEGA CORE Setup ===${NC}\n"

# Check if git is installed
if ! command -v git &> /dev/null; then
    echo -e "${RED}Error: git is not installed${NC}"
    exit 1
fi

# Check if docker is installed
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: docker is not installed${NC}"
    exit 1
fi

# Check if docker-compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}Error: docker-compose is not installed${NC}"
    exit 1
fi

echo -e "${BLUE}[1/5]${NC} Initializing git submodules..."
git submodule update --init --recursive
echo -e "${GREEN}✓ Submodules initialized${NC}\n"

echo -e "${BLUE}[2/5]${NC} Creating required directories..."
mkdir -p logs/miningcore logs/nginx logs/nurse-shark-bot ssl
echo -e "${GREEN}✓ Directories created${NC}\n"

echo -e "${BLUE}[3/5]${NC} Setting up environment configuration..."
if [ ! -f .env ]; then
    echo -e "${YELLOW}Creating .env from sample.env${NC}"
    cp sample.env .env
    echo -e "${YELLOW}⚠ IMPORTANT: Edit .env and configure your settings!${NC}"
else
    echo -e "${YELLOW}.env already exists, skipping${NC}"
fi
echo -e "${GREEN}✓ Environment configuration ready${NC}\n"

echo -e "${BLUE}[4/5]${NC} Setting up Nurse-Shark-Bot configuration..."
if [ ! -f Nurse-Shark-Bot/config.yaml ]; then
    if [ -f Nurse-Shark-Bot/config.yaml.sample ]; then
        echo -e "${YELLOW}Creating config.yaml from sample${NC}"
        cp Nurse-Shark-Bot/config.yaml.sample Nurse-Shark-Bot/config.yaml
        echo ""
        echo -e "${RED}⚠ CRITICAL: Telegram Bot Configuration Required!${NC}"
        echo -e "${YELLOW}1. Get bot token from @BotFather on Telegram${NC}"
        echo -e "${YELLOW}2. Add bot to your Telegram group/channel${NC}"
        echo -e "${YELLOW}3. Get chat ID from bot API${NC}"
        echo -e "${YELLOW}4. Edit Nurse-Shark-Bot/config.yaml with your credentials${NC}"
        echo -e "${YELLOW}5. Add Ergo wallet addresses to monitor${NC}"
        echo ""
        echo -e "${BLUE}See README.md 'Telegram Bot Configuration' section for detailed setup${NC}"
    else
        echo -e "${YELLOW}Warning: config.yaml.sample not found in Nurse-Shark-Bot${NC}"
    fi
else
    echo -e "${YELLOW}config.yaml already exists, skipping${NC}"
fi
echo -e "${GREEN}✓ Bot configuration file ready${NC}\n"

echo -e "${BLUE}[5/5]${NC} Checking deployment mode..."
if [ -f .env ]; then
    DEPLOYMENT_MODE=$(grep -E "^DEPLOYMENT_MODE=" .env | cut -d'=' -f2 | tr -d ' \r\n' || echo "all-in-one")
else
    DEPLOYMENT_MODE="all-in-one"
fi
echo -e "${GREEN}Current deployment mode: ${YELLOW}${DEPLOYMENT_MODE}${NC}\n"

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}✓ Setup complete!${NC}"
echo -e "${GREEN}========================================${NC}\n"

echo -e "${YELLOW}Next steps:${NC}"
echo -e "  1. Edit ${BLUE}.env${NC} and configure your settings"
echo -e "  2. Edit ${BLUE}Nurse-Shark-Bot/config.yaml${NC} and add your Telegram bot token"
echo -e "  3. Configure ${BLUE}ergo-miningcore/config/ergo-public-pool.json${NC} with your pool settings"
echo -e "  4. Run one of the start scripts:\n"

case "$DEPLOYMENT_MODE" in
    "all-in-one")
        echo -e "     ${GREEN}./start-all.sh${NC}          - Start all services on one server"
        ;;
    "pool-only")
        echo -e "     ${GREEN}./start-pool.sh${NC}         - Start pool server only"
        ;;
    "services-only")
        echo -e "     ${GREEN}./start-services.sh${NC}     - Start services server only"
        ;;
    *)
        echo -e "     ${GREEN}./start-all.sh${NC}          - Start all services on one server"
        echo -e "     ${GREEN}./start-pool.sh${NC}         - Start pool server only"
        echo -e "     ${GREEN}./start-services.sh${NC}     - Start services server only"
        ;;
esac

echo -e "\n${YELLOW}Documentation: See README.md for detailed instructions${NC}\n"
