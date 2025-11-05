#!/usr/bin/env bash
# ===========================================
# Sigmanaut Mining Pool - Services Server Start
# ===========================================
# Starts only services (Mining Wave API, Dashboard, Nurse Shark Bot, Nginx)
# Requires connection to remote pool server

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}=== Starting SIGS MEGA CORE (Services Server Only) ===${NC}\n"

# Check if .env exists
if [ ! -f .env ]; then
    echo -e "${RED}Error: .env file not found${NC}"
    echo -e "${YELLOW}Please run ./setup.sh first${NC}"
    exit 1
fi

# Check if POOL_SERVER_IP is set
source .env
if [ -z "$POOL_SERVER_IP" ]; then
    echo -e "${RED}Error: POOL_SERVER_IP not set in .env${NC}"
    echo -e "${YELLOW}Please edit .env and set the IP address of your pool server${NC}"
    exit 1
fi

# Check if submodules are initialized
if [ ! -d mining-wave/secondary_server ]; then
    echo -e "${YELLOW}Warning: Submodules not initialized${NC}"
    echo -e "${YELLOW}Please run ./setup.sh first${NC}"
    exit 1
fi

DASHBOARD_PORT_VALUE=${DASHBOARD_PORT:-8888}

echo -e "${BLUE}Pool server IP: ${POOL_SERVER_IP}${NC}"
echo -e "${BLUE}Testing connection to pool server database...${NC}\n"

# Test connection to pool server (optional but recommended)
if command -v nc &> /dev/null; then
    if ! nc -z -w5 "$POOL_SERVER_IP" "${POSTGRES_PORT:-5432}" 2>/dev/null; then
        echo -e "${YELLOW}Warning: Cannot connect to pool server PostgreSQL${NC}"
        echo -e "${YELLOW}Make sure the pool server is running and firewall allows connection${NC}"
        read -p "Continue anyway? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    else
        echo -e "${GREEN}✓ Connection to pool server database successful${NC}\n"
    fi
fi

echo -e "${BLUE}Starting services using docker-compose.services.yml...${NC}\n"

# Start services
docker-compose -f docker-compose.services.yml up -d

echo -e "\n${GREEN}Checking service status...${NC}\n"
docker-compose -f docker-compose.services.yml ps

echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}✓ Services server started!${NC}"
echo -e "${GREEN}========================================${NC}\n"

echo -e "${YELLOW}Service URLs:${NC}"
echo -e "  Mining Wave API:   ${BLUE}http://localhost:8000${NC}"
echo -e "  Dashboard Public:  ${BLUE}http://localhost:${DASHBOARD_PORT_VALUE}/public/${NC}"
echo -e "  Dashboard Admin:   ${BLUE}http://localhost:${DASHBOARD_PORT_VALUE}/admin/${NC}"
echo -e "  Nginx Proxy:       ${BLUE}http://localhost${NC}\n"

echo -e "${YELLOW}Useful commands:${NC}"
echo -e "  View logs:        ${BLUE}docker-compose -f docker-compose.services.yml logs -f${NC}"
echo -e "  Stop all:         ${BLUE}docker-compose -f docker-compose.services.yml down${NC}"
echo -e "  Restart service:  ${BLUE}docker-compose -f docker-compose.services.yml restart <service>${NC}\n"
