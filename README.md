# UniZ Infrastructure

**Repository**: `uniz-infra`
**Role**: Orchestration & Deployment for the UniZ Microservices Stack.

This repository is the entry point for the entire UniZ system. Use the scripts below to set up and run the system on **any machine** with Docker installed.

---

## 🚀 Any Machine Setup (Source)

To run the complete system from source on a fresh machine:

### 1. Prerequisite
Ensure [Docker](https://www.docker.com/) and [Node.js](https://nodejs.org/) are installed.

### 2. Clone the Infrastructure
```bash
git clone https://github.com/uniz-rguktong/uniz-infra.git
cd uniz-infra
```

### 3. Bootstrap (Clone all Services)
This script will automatically clone the frontend and all backend services into the parent directory.
```bash
chmod +x bootstrap.sh
./bootstrap.sh
```

### 4. Run the System
This command starts Docker containers, syncs databases, and launches the frontend dashboard.
```bash
chmod +x start.sh
./start.sh
```

---

## 🏥 Service Monitoring

*   **Frontend Dashboard**: [http://localhost:5173](http://localhost:5173)
*   **API Gateway**: [http://localhost:3000/api/v1](http://localhost:3000/api/v1)
*   **Health Status**: [http://localhost:3000/health](http://localhost:3000/health)

### View Logs
To see logs across all services:
```bash
docker-compose -f docker/docker-compose.yml logs -f
```

---

## 🏗 System Architecture
UniZ is built on an event-driven microservices architecture:
*   **Gateway**: Entry point & Rate limiting.
*   **Auth**: Identity & JWT management.
*   **User**: Profile & Role handling.
*   **Outpass**: Core workflow logic.
*   **Notification**: Async workers (Redis/BullMQ).
*   **Cron**: Scheduled tasks.
