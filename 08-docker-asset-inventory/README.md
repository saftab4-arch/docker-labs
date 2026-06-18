# Project 08 - Docker Asset Inventory & Environment Reporting Tool

## Overview

The Docker Asset Inventory & Environment Reporting Tool is a Bash script that automatically collects Docker-related information from a Linux host and generates a timestamped report.

This project is useful for:

* Environment documentation
* Server audits
* Incident response
* Troubleshooting
* DevOps asset inventory
* Migration planning

---

# Script

#!/bin/bash

set -euo pipefail

TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
REPORT_DIR="reports"
REPORT_FILE="$REPORT_DIR/docker_inventory_$TIMESTAMP.log"

mkdir -p "$REPORT_DIR"

exec > >(tee "$REPORT_FILE") 2>&1

echo "================================="
echo "Docker Asset Inventory Report"
echo "Generated: $(date)"
echo "================================="
echo

echo "===== HOST INFORMATION ====="
hostname
uptime
uname -a
hostname -I
echo

echo "===== DOCKER VERSION ====="
docker --version
docker compose version
echo

echo "===== RUNNING CONTAINERS ====="
docker ps
echo

echo "===== ALL CONTAINERS ====="
docker ps -a
echo

echo "===== IMAGES ====="
docker image ls
echo

echo "===== VOLUMES ====="
docker volume ls
echo

echo "===== NETWORKS ====="
docker network ls
echo

echo "===== DOCKER DISK USAGE ====="
docker system df
echo

echo "===== SWARM INFORMATION ====="

docker info | grep Swarm

if docker info | grep -q "active"; then
    echo
    docker node ls
    echo
    docker service ls
    echo
    docker stack ls
fi

echo

echo "===== CONTAINER RESOURCE USAGE ====="
docker stats --no-stream
echo

echo "===== SUMMARY ====="

echo "Containers: $(docker ps -aq | wc -l)"
echo "Running Containers: $(docker ps -q | wc -l)"
echo "Images: $(docker image ls -q | wc -l)"
echo "Volumes: $(docker volume ls -q | wc -l)"
echo "Networks: $(docker network ls -q | wc -l)"

echo
echo "Report saved to: $REPORT_FILE"

# Features

* Host information collection
* Docker version information
* Running containers inventory
* All containers inventory
* Docker image inventory
* Volume inventory
* Network inventory
* Docker disk usage report
* Swarm detection
* Swarm node information
* Service information
* Stack information
* Container resource usage
* Summary statistics
* Timestamped report generation

---

# Project Structure

```text
08-docker-asset-inventory/

├── docker_inventory.sh
├── README.md
├── reports/
│
└── screenshots/
```

---

# Requirements

* Linux
* Docker
* Docker Compose
* Bash

---

# Script Workflow

```text
Host Information
        ↓
Docker Version
        ↓
Containers
        ↓
Images
        ↓
Volumes
        ↓
Networks
        ↓
Disk Usage
        ↓
Swarm Information
        ↓
Container Statistics
        ↓
Summary Report
```

---

# Host Information

Collects:

* Hostname
* Uptime
* Kernel information
* IP addresses

Commands used:

```bash
hostname
uptime
uname -a
hostname -I
```

---

# Docker Information

Collects:

```bash
docker --version
docker compose version
```

---

# Container Inventory

Running containers:

```bash
docker ps
```

All containers:

```bash
docker ps -a
```

Information includes:

* Container ID
* Image
* Status
* Ports
* Names

---

# Image Inventory

Command:

```bash
docker image ls
```

Displays:

* Repository
* Tag
* Image ID
* Size

---

# Volume Inventory

Command:

```bash
docker volume ls
```

Useful for identifying persistent storage resources.

---

# Network Inventory

Command:

```bash
docker network ls
```

Displays:

* Bridge networks
* Overlay networks
* Host network
* None network

---

# Docker Disk Usage

Command:

```bash
docker system df
```

Displays:

* Image usage
* Container usage
* Volume usage
* Build cache usage

---

# Swarm Detection

Command:

```bash
docker info | grep Swarm
```

If Swarm mode is active, the script automatically collects:

## Nodes

```bash
docker node ls
```

## Services

```bash
docker service ls
```

## Stacks

```bash
docker stack ls
```

---

# Container Resource Usage

Command:

```bash
docker stats --no-stream
```

Displays:

* CPU usage
* Memory usage
* Network I/O
* Block I/O

---

# Report Generation

Reports are stored inside:

```text
reports/
```

Example:

```text
reports/docker_inventory_2026-06-19_09-35-20.log
```

Reports are timestamped automatically.

---

# Summary Section

The script generates a summary containing:

* Total containers
* Running containers
* Images
* Volumes
* Networks

Commands used:

```bash
docker ps -aq | wc -l
docker ps -q | wc -l
docker image ls -q | wc -l
docker volume ls -q | wc -l
docker network ls -q | wc -l
```

---

# Important Bash Concepts

## set -euo pipefail

### -e

Exit immediately if a command fails.

### -u

Treat undefined variables as errors.

### pipefail

Return failure if any command inside a pipeline fails.

---

## Pipe Operator

```bash
|
```

Passes output from one command to another.

Example:

```bash
docker ps -q | wc -l
```

Counts running containers.

---

## -q Flag

Quiet mode.

Returns IDs only.

Example:

```bash
docker ps -q
docker image ls -q
docker volume ls -q
docker network ls -q
```

Useful for counting resources.

---

# Example Execution

```bash
chmod +x docker_inventory.sh

./docker_inventory.sh
```

Output:

```text
Docker Asset Inventory Report

HOST INFORMATION
DOCKER VERSION
RUNNING CONTAINERS
ALL CONTAINERS
IMAGES
VOLUMES
NETWORKS
DISK USAGE
SWARM INFORMATION
CONTAINER STATS
SUMMARY

Report saved to:
reports/docker_inventory_YYYY-MM-DD_HH-MM-SS.log
```

---

# Skills Practiced

* Bash scripting
* Variables
* Pipes
* Error handling
* Docker CLI
* Docker Swarm
* Reporting
* Linux administration
* Environment auditing
* Infrastructure inventory

---

# Future Improvements

* JSON output
* CSV export
* HTML reports
* Email notifications
* Slack notifications
* Volume inspection details
* Container environment variables
* Mount information
* Resource thresholds
* Scheduled execution with cron

---

## Technologies Used

* Linux
* Bash
* Docker
* Docker Compose
* Docker Swarm

---

Author

Syed Aftab

Project

Project 08 - Docker Asset Inventory & Environment Reporting Tool
