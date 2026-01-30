#!/bin/bash
# UniZ Microservices Master Start Script (Cross-Platform Ready)

# Get current script path
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT_DIR="$( cd "$SCRIPT_DIR/.." && pwd )"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🚀 Starting UniZ Microservices Stack...${NC}"

# Check for Docker
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo -e "❌ ${RED}Docker Compose not found. Please install Docker.${NC}"
    exit 1
fi

# 1. Start Infrastructure
cd "$SCRIPT_DIR/docker"
docker-compose up -d

echo -e "⏳ ${BLUE}Waiting for Database to warm up...${NC}"
sleep 5

# 2. Database Schema Sync
echo -e "📦 ${BLUE}Synchronizing Database Schemas...${NC}"

sync_db() {
  local service_name=$1
  local schema_name=$2
  echo -e "  - ${BLUE}$service_name${NC} ($schema_name)"
  
  if [ -d "$ROOT_DIR/$service_name" ]; then
    export DATABASE_URL="postgresql://user:password@localhost:5432/uniz_db?schema=$schema_name"
    (cd "$ROOT_DIR/$service_name" && npx prisma db push --accept-data-loss --skip-generate > /dev/null 2>&1)
  else
    echo -e "  ⚠️ ${RED}Directory $service_name missing. Run bootstrap.sh first.${NC}"
  fi
}

sync_db "uniz-auth-service" "auth"
sync_db "uniz-user-service" "users"
sync_db "uniz-outpass-service" "outpass"
sync_db "uniz-cron-service" "public"

# 3. Launch Frontend
echo -e "🌐 ${BLUE}Launching Frontend Dashboard...${NC}"
if [ -d "$ROOT_DIR/uniz-client" ]; then
  (cd "$ROOT_DIR/uniz-client" && npm install > /dev/null && npm run dev -- --port 5173 --host > /dev/null 2>&1 &)
else
  echo -e "  ⚠️ ${RED}uniz-client directory missing.${NC}"
fi

echo -e "\n${GREEN}✅ UniZ System is Online!${NC}"
echo -e "------------------------------------------------"
echo -e "🖥  ${GREEN}Frontend:${NC} http://localhost:5173"
echo -e "🛠  ${GREEN}API Gateway:${NC} http://localhost:3000/api/v1"
echo -e "📊 ${GREEN}Health Check:${NC} http://localhost:3000/health"
echo -e "------------------------------------------------"
echo -e "💡 View logs with: ${BLUE}docker-compose -f $SCRIPT_DIR/docker/docker-compose.yml logs -f${NC}\n"

# Verify Gateway
curl -s http://localhost:3000/health | grep -q "ok" && echo -e "${GREEN}API Gateway is responding.${NC}" || echo -e "${RED}Gateway start pending.${NC}"
