#!/usr/bin/env bash
# ===========================================
# Sigmanaut Mining Pool - Pool Server Start
# ===========================================
# Starts only pool-critical services (PostgreSQL, Redis, Miningcore, Nginx)

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}=== Starting SIGS MEGA CORE (Pool Server Only) ===${NC}\n"

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

echo -e "${BLUE}Starting pool server services using docker-compose.pool.yml...${NC}\n"

# Start pool services
docker-compose -f docker-compose.pool.yml up -d

echo -e "\n${GREEN}Checking service status...${NC}\n"
docker-compose -f docker-compose.pool.yml ps

echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}✓ Pool server started!${NC}"
echo -e "${GREEN}========================================${NC}\n"

echo -e "${YELLOW}Service URLs:${NC}"
echo -e "  Miningcore API:   ${BLUE}http://localhost:4000/api/pools${NC}"
echo -e "  Stratum (mining): ${BLUE}stratum+tcp://localhost:4444${NC}"
echo -e "  Stratum SSL:      ${BLUE}stratum+ssl://localhost:7777${NC}"
echo -e "  PostgreSQL:       ${BLUE}postgresql://localhost:5432${NC}\n"

echo -e "${RED}IMPORTANT:${NC} ${YELLOW}PostgreSQL is exposed on port 5432 for remote access${NC}"
echo -e "${YELLOW}Make sure to configure firewall rules to allow access from services server${NC}\n"

echo -e "${YELLOW}Useful commands:${NC}"
echo -e "  View logs:        ${BLUE}docker-compose -f docker-compose.pool.yml logs -f${NC}"
echo -e "  Stop all:         ${BLUE}docker-compose -f docker-compose.pool.yml down${NC}"
echo -e "  Restart service:  ${BLUE}docker-compose -f docker-compose.pool.yml restart <service>${NC}\n"
