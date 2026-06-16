# Project 04 - Container Resource Monitoring & Capacity Reporting

## Project Overview

This project demonstrates several core Docker concepts used in real-world DevOps environments:

- Multi-Stage Docker Builds
- Docker Images
- Docker Containers
- Volume Mapping (Bind Mounts)
- Resource Monitoring
- Capacity Reporting

The goal was to:

1. Create a Multi-Stage Dockerfile
2. Build a Docker Image
3. Run a Docker Container
4. Mount a Host Directory into the Container
5. Verify Data Persistence
6. Generate Container Resource Reports

---

# Architecture

Host Machine
|
├── Shared Data Folder
│ └── notes.txt
│
├── Docker Image
│ └── multistage-lab
│
└── Docker Container
└── multistage-container
|
└── /data
|
└── notes.txt

---

# Step 1 - Create Project Directory

```bash
mkdir project-04-multistage-resource-monitoring

cd project-04-multistage-resource-monitoring
```

---

# Step 2 - Create Application File

Create a simple HTML application.

```bash
nano index.html
```

Contents:

```html
<!DOCTYPE html>
<html>
<head>
    <title>Multi Stage Docker Lab</title>
</head>
<body>
    <h1>Container Resource Monitoring Lab</h1>
</body>
</html>
```

---

# Step 3 - Create Multi-Stage Dockerfile

```bash
nano Dockerfile
```

Contents:

```dockerfile
# Stage 1 - Builder

FROM node:24 AS builder

WORKDIR /app

COPY index.html .

# Stage 2 - Runtime

FROM nginx:latest

COPY --from=builder /app/index.html /usr/share/nginx/html/index.html
```

---

# Understanding the Multi-Stage Build

## Builder Stage

```dockerfile
FROM node:24 AS builder
```

Creates a temporary build environment.

---

```dockerfile
WORKDIR /app
```

Creates and moves into:

```text
/app
```

---

```dockerfile
COPY index.html .
```

Copies the application file into:

```text
/app/index.html
```

---

## Runtime Stage

```dockerfile
FROM nginx:latest
```

Creates the final lightweight container.

---

```dockerfile
COPY --from=builder /app/index.html /usr/share/nginx/html/index.html
```

Copies only the required file from the builder stage into nginx.

Benefits:

- Smaller Image
- Better Security
- Faster Deployment
- Production Ready Design

---

# Step 4 - Build Docker Image

```bash
docker build -t multistage-lab .
```

Verify:

```bash
docker images
```

Expected Output:

```text
multistage-lab    latest
```

---

# Step 5 - Create Shared Host Directory

Move back to docker-labs directory:

```bash
cd ..
```

Create a shared folder:

```bash
mkdir shared-data

cd shared-data
```

Create file:

```bash
nano notes.txt
```

Contents:

```text
Pakistan Cricket Team should be removed from ICC
```

Verify:

```bash
cat notes.txt
```

---

# Step 6 - Verify Full Host Path

```bash
pwd
```

Example:

```text
/home/syedaftab04/docker-labs/shared-data
```

---

# Step 7 - Run Docker Container

Create container and mount volume.

```bash
docker run -d \
--name multistage-container \
-p 8080:80 \
-v /home/syedaftab04/docker-labs/shared-data:/data \
multistage-lab
```

---

# Understanding the Volume Mapping

```bash
-v /home/syedaftab04/docker-labs/shared-data:/data
```

Host:

```text
/home/syedaftab04/docker-labs/shared-data
```

Container:

```text
/data
```

Anything inside the host folder becomes available inside the container.

---

# Step 8 - Verify Running Container

```bash
docker ps
```

Expected Output:

```text
multistage-container
```

---

# Step 9 - Verify Web Application

Open browser:

```text
http://localhost:8080
```

Expected Output:

```text
Container Resource Monitoring Lab
```

---

# Step 10 - Verify Volume Mount

Enter the container:

```bash
docker exec -it multistage-container sh
```

View mounted directory:

```bash
cd /data

ls
```

Expected Output:

```text
notes.txt
```

Display file:

```bash
cat notes.txt
```

Output:

```text
Pakistan Cricket Team should be removed from ICC
```

Exit container:

```bash
exit
```

---

# Step 11 - Create Resource Monitoring Script

```bash
nano resource-monitor.sh
```

Contents:

```bash
#!/bin/bash

REPORT="capacity-report.txt"

echo "===================================" > $REPORT
echo "Container Capacity Report" >> $REPORT
echo "===================================" >> $REPORT

echo "" >> $REPORT
echo "Date: $(date)" >> $REPORT

echo "" >> $REPORT
echo "Running Containers" >> $REPORT
echo "-----------------------------------" >> $REPORT

docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Image}}" >> $REPORT

echo "" >> $REPORT
echo "Container Resource Usage" >> $REPORT
echo "-----------------------------------" >> $REPORT

docker stats --no-stream >> $REPORT

echo "" >> $REPORT
echo "Report Generated Successfully" >> $REPORT

cat $REPORT
```

---

# Step 12 - Make Script Executable

```bash
chmod +x resource-monitor.sh
```

---

# Step 13 - Run Monitoring Script

```bash
./resource-monitor.sh
```

Example Output:

```text
Container Capacity Report

Running Containers

multistage-container

Container Resource Usage

CPU %
MEM %
NET I/O
BLOCK I/O
PIDS
```

---

# Important Docker Concepts Learned

## Multi-Stage Docker Build

Allows separate build and runtime stages.

Benefits:

- Smaller Images
- Better Security
- Faster Deployments

---

## Docker Image

Blueprint used to create containers.

Created with:

```bash
docker build
```

---

## Docker Container

Running instance of an image.

Created with:

```bash
docker run
```

---

## Volume Mapping

Maps host storage into a container.

Example:

```bash
-v host-path:container-path
```

Benefits:

- Data Persistence
- Shared Storage
- Backup Friendly

---

## Docker Monitoring

Useful Commands:

```bash
docker ps
```

List running containers.

```bash
docker stats
```

Live resource usage.

```bash
docker inspect
```

Detailed container information.

```bash
docker logs
```

View application logs.

---

# Skills Practiced

- Multi-Stage Dockerfiles
- Docker Image Management
- Docker Container Deployment
- Nginx Runtime Containers
- Volume Mapping
- Resource Monitoring
- Capacity Reporting
- Container Investigation

---

# Project Outcome

Successfully:

- Built a Multi-Stage Docker Image
- Created a Docker Container
- Mounted Host Storage into Container
- Verified Data Persistence
- Monitored Container Resource Usage
- Generated Capacity Reports

This project simulates real-world container operations commonly performed by DevOps Engineers and Cloud Engineers.
