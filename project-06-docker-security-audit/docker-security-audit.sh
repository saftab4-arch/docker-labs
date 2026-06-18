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
