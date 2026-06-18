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
