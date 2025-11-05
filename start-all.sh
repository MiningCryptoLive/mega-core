#!/usr/bin/env bash
# ===========================================
# Sigmanaut Mining Pool - Full Stack Start
# ===========================================
# Starts all services on a single server

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${GREEN}=== Starting SIGS MEGA CORE (Full Stack) ===${NC}\n"

# Check if .env exists
if [ ! -f .env ]; then
    echo -e "${YELLOW}Warning: .env file not found${NC}"
    echo -e "${YELLOW}Please run ./setup.sh first${NC}"
    exit 1
fi

# Check if submodules are initialized
if [ ! -f ergo-miningcore/Dockerfile ]; then
    echo -e "${YELLOW}Warning: Submodules not initialized${NC}"
    echo -e "${YELLOW}Please run ./setup.sh first${NC}"
    exit 1
fi

DASHBOARD_PORT_VALUE=${DASHBOARD_PORT:-8888}

echo -e "${BLUE}Starting all services using docker-compose.yml...${NC}\n"

# Start all services
docker-compose up -d

echo -e "\n${GREEN}Checking service status...${NC}\n"
docker-compose ps

echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}✓ All services started!${NC}"
echo -e "${GREEN}========================================${NC}\n"

echo -e "${YELLOW}Service URLs:${NC}"
echo -e "  Miningcore API:   ${BLUE}http://localhost:4000/api/pools${NC}"
echo -e "  Mining Wave API:  ${BLUE}http://localhost:8000${NC}"
echo -e "  Dashboard Public: ${BLUE}http://localhost:${DASHBOARD_PORT_VALUE}/public/${NC}"
echo -e "  Dashboard Admin:  ${BLUE}http://localhost:${DASHBOARD_PORT_VALUE}/admin/${NC}"
echo -e "  Stratum (mining): ${BLUE}stratum+tcp://localhost:4444${NC}"
echo -e "  Stratum SSL:      ${BLUE}stratum+ssl://localhost:7777${NC}\n"

echo -e "${YELLOW}Useful commands:${NC}"
echo -e "  View logs:        ${BLUE}docker-compose logs -f${NC}"
echo -e "  Stop all:         ${BLUE}docker-compose down${NC}"
echo -e "  Restart service:  ${BLUE}docker-compose restart <service>${NC}\n"
