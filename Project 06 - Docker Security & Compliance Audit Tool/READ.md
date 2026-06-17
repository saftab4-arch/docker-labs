# Project 06 - Docker Security & Compliance Audit Tool

## Overview

This project simulates a real-world Docker environment consisting of multiple containers managed by Docker Compose.

The project demonstrates:

* Container Networking
* Persistent Storage with Named Volumes
* PostgreSQL Database Services
* Ubuntu Audit Container
* Docker DNS
* Custom Docker Security Audit Script
* Docker Compose Deployments

---

## Environment Components

* Nginx Web Server
* PostgreSQL Database
* Ubuntu Audit Container
* Custom Bridge Network
* Named Docker Volumes
* Automated Security Audit Script
* Docker Compose Deployment

---

# Architecture

```text
security-net
172.18.0.0/16 bridge

──────────────────────────────────────

audit-tool
Ubuntu
172.18.0.2

        │
        │
 ┌──────┴──────┐
 │             │
 ▼             ▼

nginx       postgres
172.18.0.3  172.18.0.4

 │             │
 ▼             ▼

nginx-logs   postgres-data
 volume       volume

audit-data volume
        │
        ▼

docker-security-audit.sh

reports/
docker-audit-yyyy-mm-dd.txt
```

---

# Technologies Used

* Docker
* Docker Compose
* Nginx
* PostgreSQL
* Ubuntu
* Bash
* Custom Bridge Networks
* Named Volumes

---

# Project Structure

```text
project-06-docker-security-audit/

├── docker-compose.yml
├── docker-security-audit.sh
├── postgres.env
├── README.md
└── reports/
```

---

# Custom Network

Created manually:

```bash
docker network create security-net
```

Verify:

```bash
docker network ls
```

---

# Named Volumes

Created manually:

```bash
docker volume create postgres-data
docker volume create nginx-logs
docker volume create audit-data
```

Verify:

```bash
docker volume ls
```

---

# Docker Compose Configuration

```yaml
services:

  nginx:
    image: nginx
    container_name: nginx

    ports:
      - "8080:80"

    networks:
      - security-net

    volumes:
      - nginx-logs:/var/log/nginx

  postgres:
    image: postgres
    container_name: postgres

    ports:
      - "5432:5432"

    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: StrongPassword123
      POSTGRES_DB: companydb

    networks:
      - security-net

    volumes:
      - postgres-data:/var/lib/postgresql

  audit-tool:
    image: ubuntu
    container_name: audit-tool

    command: sleep infinity

    networks:
      - security-net

    volumes:
      - audit-data:/reports

networks:

  security-net:
    external: true

volumes:

  postgres-data:
    external: true

  nginx-logs:
    external: true

  audit-data:
    external: true
```

---

# Docker Compose YAML Explanation

## image

Specifies which Docker image to pull.

Example:

```yaml
image: nginx
```

Equivalent:

```bash
docker run nginx
```

---

## container_name

Assigns a friendly name to the container.

Example:

```yaml
container_name: postgres
```

---

## ports

Maps host ports to container ports.

Example:

```yaml
ports:
  - "8080:80"
```

Meaning:

```text
Host Port 8080
      │
      ▼
Container Port 80
```

---

## environment

Creates environment variables inside the container.

Example:

```yaml
environment:
  POSTGRES_USER: postgres
```

Equivalent:

```bash
-e POSTGRES_USER=postgres
```

---

## networks

Connects the container to a custom Docker network.

Example:

```yaml
networks:
  - security-net
```

Equivalent:

```bash
--network security-net
```

---

## volumes

Maps Docker named volumes into containers.

Example:

```yaml
volumes:
  - postgres-data:/var/lib/postgresql
```

Meaning:

```text
Docker Volume
      │
      ▼
postgres-data
      │
      ▼
Container Path
/var/lib/postgresql
```

---

## external: true

Tells Docker Compose:

```text
Do NOT create this resource.

Use an existing Docker network or volume.
```

---

# Deploy Environment

Start the environment:

```bash
docker compose up -d
```

Verify:

```bash
docker ps
```

---

# Container Connectivity Testing

Enter the audit container:

```bash
docker exec -it audit-tool bash
```

Install ping:

```bash
apt update
apt install iputils-ping -y
```

Test connectivity:

```bash
ping nginx
ping postgres
```

Docker DNS automatically resolves container names.

---

# HTTP Connectivity Test

Install curl:

```bash
apt install curl -y
```

Test Nginx:

```bash
curl http://nginx
```

Expected output:

```text
Welcome to nginx!
```

---

# PostgreSQL Connectivity Test

Install PostgreSQL client:

```bash
apt install postgresql-client -y
```

Connect:

```bash
psql -h postgres -U postgres
```

List databases:

```sql
\l
```

Expected databases:

```text
companydb
postgres
template0
template1
```

---

# Docker Security Audit Script

Run:

```bash
./docker-security-audit.sh
```

Creates:

```text
reports/docker-audit-yyyy-mm-dd.txt
```

---

# Script Audits

The script collects:

## Running Containers

```bash
docker ps
```

## Docker Images

```bash
docker images
```

## Networks

```bash
docker network ls
docker network inspect security-net
```

## Volumes

```bash
docker volume ls
```

## Resource Usage

```bash
docker stats --no-stream
```

## Port Exposure

```bash
docker ps --format
```

## Container Configuration

```bash
docker inspect nginx
docker inspect postgres
docker inspect audit-tool
```

---

# Troubleshooting

## Ubuntu Container Exits Immediately

Keep container alive:

```yaml
command: sleep infinity
```

---

## Docker Desktop Virtualization Error

Enable:

* Intel VT-x / AMD-V
* Virtual Machine Platform
* Windows Hypervisor Platform
* Windows Subsystem for Linux

Restart WSL:

```bash
wsl --shutdown
```

Verify:

```bash
wsl --status
```

Expected:

```text
Default Version: 2
```

---

## Verify Network

```bash
docker network inspect security-net
```

---

## Verify Volumes

```bash
docker volume inspect postgres-data
```

---

# Resume Project Description

### Docker Security & Compliance Audit Tool

Built a multi-container Docker environment using Docker Compose with Nginx, PostgreSQL, and Ubuntu audit containers.

Implemented custom bridge networking and persistent named volumes.

Developed a Bash-based Docker security audit tool generating timestamped compliance reports.

Validated container-to-container communication using Docker DNS, ping, curl, and PostgreSQL client connectivity.

Performed container inspection, resource monitoring, network auditing, and port exposure analysis.

---

# Bash Script

#!/bin/bash

REPORT_DIR="./reports"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
REPORT_FILE="$REPORT_DIR/docker-audit-$TIMESTAMP.txt"

mkdir -p "$REPORT_DIR"

{
echo "========================================"
echo " Docker Security Audit Report"
echo " Generated: $(date)"
echo "========================================"

echo
echo "===== Running Containers ====="
docker ps

echo
echo "===== Images ====="
docker images

echo
echo "===== Networks ====="
docker network ls

echo
echo "===== Volumes ====="
docker volume ls

echo
echo "===== Container Resource Usage ====="
docker stats --no-stream

echo
echo "===== Port Mappings ====="
docker ps --format "table {{.Names}}\t{{.Ports}}"

echo
echo "===== Security-Net Details ====="
docker network inspect security-net

echo
echo "===== Nginx Details ====="
docker inspect nginx

echo
echo "===== Postgres Details ====="
docker inspect postgres

echo
echo "===== Audit Tool Details ====="
docker inspect audit-tool

echo
echo "===== Finished ====="

} > "$REPORT_FILE"

echo "Audit report saved to:"
echo "$REPORT_FILE"

# Skills Demonstrated

* Docker
* Docker Compose
* Container Networking
* Docker DNS
* Named Volumes
* Bash Scripting
* PostgreSQL
* Nginx
* Linux
* Container Security
* Resource Monitoring
* Infrastructure as Code
* Troubleshooting
* DevOps Fundamentals
* SRE Concepts

---

# Real-World Relevance

This project simulates a small production environment and demonstrates many tasks performed by:

* DevOps Engineers
* Platform Engineers
* Site Reliability Engineers (SREs)
* Cloud Engineers
* Infrastructure Engineers

during container deployment, auditing, troubleshooting, and operational monitoring.
