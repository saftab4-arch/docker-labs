# Project 05 - Failed Container Investigation Toolkit

## Project Overview
This project simulates a real-world Docker container failure and demonstrates how DevOps Engineers investigate, diagnose, and resolve container startup issues using Docker-native troubleshooting tools and Bash automation.

### Technologies Used
- Docker
- Nginx
- Node.js
- Bash
- Linux
- Docker CLI

## Project Objectives
1. Create a Multi-Stage Docker Image
2. Deploy a Container with an Intentional Failure
3. Investigate the Failure
4. Identify the Root Cause
5. Fix the Container
6. Redeploy the Application
7. Build an Automated Investigation Toolkit
8. Generate Reports for All Containers

---

# Architecture

```text
Builder Stage (Node)
        |
        v
Runtime Stage (Nginx)
        |
        v
Docker Image (failed-lab)
        |
        v
Failed Container
        |
        v
Docker Logs + Docker Inspect
        |
        v
Root Cause Analysis
        |
        v
Container Fix
        |
        v
Automated Investigation Toolkit
```

# Project Structure

```text
project-05-failed-container-investigation/
├── Dockerfile
├── index.html
├── investigate.sh
├── report.txt
└── README.md
```

# Application File

```html
<!DOCTYPE html>
<html>
<head>
    <title>Failed Container Investigation</title>
</head>
<body>
    <h1>Project 05 - Failed Container Investigation</h1>
</body>
</html>
```

# Initial Multi-Stage Dockerfile (Broken)

```dockerfile
FROM node:24 AS builder

WORKDIR /app

COPY index.html .

FROM nginx:latest

COPY --from=builder /app/index.html /usr/share/nginx/html/index.html

CMD ["fake-command"]
```

## Dockerfile Explanation

### FROM node:24 AS builder
Creates a temporary build environment.

### WORKDIR /app
Creates and switches to /app.

### COPY index.html .
Copies index.html into the build stage.

### FROM nginx:latest
Creates the runtime image.

### COPY --from=builder
Copies only required artifacts into the runtime image.

### CMD ["fake-command"]
Intentional failure used for troubleshooting practice.

---

# Build Docker Image

```bash
docker build -t failed-lab .
```

### Flags
- docker build = build image
- -t = tag image
- failed-lab = image name
- . = current build context

Verify:

```bash
docker images
```

---

# Run Failed Container

```bash
docker run -d --name failed-container failed-lab
```

### Flags
- docker run = create container
- -d = detached mode
- --name = custom container name

---

# Investigation

## Check Running Containers

```bash
docker ps
```

## Check All Containers

```bash
docker ps -a
```

Expected:

```text
failed-container
Exited (127)
```

---

# Docker Logs

```bash
docker logs failed-container
```

Output:

```text
fake-command: not found
```

---

# Docker Inspect

Full metadata:

```bash
docker inspect failed-container
```

Exit code only:

```bash
docker inspect failed-container --format='{{.State.ExitCode}}'
```

Startup command:

```bash
docker inspect failed-container --format='{{.Config.Cmd}}'
```

---

# Understanding --format

Docker uses Go Templates.

Example:

```bash
{{.State.ExitCode}}
```

Returns:

```text
127
```

Example:

```bash
{{.Config.Cmd}}
```

Returns:

```text
[fake-command]
```

---

# Common Exit Codes

| Code | Meaning |
|------|---------|
| 0 | Success |
| 1 | General Error |
| 125 | Docker Error |
| 126 | Permission Denied |
| 127 | Command Not Found |
| 137 | OOM Killed |
| 255 | Unexpected Termination |

---

# Root Cause Analysis

Container exited with:

```text
127
```

Meaning:

```text
Command Not Found
```

Docker attempted to run:

```text
fake-command
```

which does not exist.

---

# Fix Dockerfile

Replace:

```dockerfile
CMD ["fake-command"]
```

with:

```dockerfile
CMD ["nginx","-g","daemon off;"]
```

## Explanation

### nginx
Starts the web server.

### -g
Global configuration directive.

### daemon off;
Keeps Nginx running in the foreground.

Without it, Docker sees the main process exit and stops the container.

---

# Rebuild Image

```bash
docker build -t failed-lab .
```

# Remove Old Container

```bash
docker rm failed-container
```

# Run Fixed Container

```bash
docker run -d --name fixed-container -p 8085:80 failed-lab
```

## Port Mapping

```bash
-p 8085:80
```

Host Port:
8085

Container Port:
80

Open:

```text
http://localhost:8085
```

---

# Final Investigation Script

```bash
#!/bin/bash

REPORT="report.txt"

echo "==================================" > $REPORT
echo "Docker Investigation Report" >> $REPORT
echo "==================================" >> $REPORT

echo "" >> $REPORT
echo "Date: $(date)" >> $REPORT

for CONTAINER in $(docker ps -a --format "{{.Names}}")
do

echo "" >> $REPORT
echo "==================================" >> $REPORT
echo "Container: $CONTAINER" >> $REPORT
echo "==================================" >> $REPORT

echo "" >> $REPORT
echo "Status:" >> $REPORT

docker inspect $CONTAINER \
--format='{{.State.Status}}' >> $REPORT

echo "" >> $REPORT
echo "Exit Code:" >> $REPORT

docker inspect $CONTAINER \
--format='{{.State.ExitCode}}' >> $REPORT

echo "" >> $REPORT
echo "Configured CMD:" >> $REPORT

docker inspect $CONTAINER \
--format='{{.Config.Cmd}}' >> $REPORT

echo "" >> $REPORT
echo "Recent Logs:" >> $REPORT

docker logs $CONTAINER 2>&1 | tail -5 >> $REPORT

done

cat $REPORT
```

# Script Breakdown

## REPORT Variable

```bash
REPORT="report.txt"
```

Stores report filename.

## >

Overwrite file.

## >>

Append to file.

## $(date)

Command substitution.

## docker ps -a

Lists all containers.

## --format "{{.Names}}"

Returns only container names.

## For Loop

```bash
for CONTAINER in ...
```

Iterates through all containers.

## docker inspect

Retrieves metadata.

## {{.State.Status}}

Returns running/exited status.

## {{.State.ExitCode}}

Returns exit code.

## {{.Config.Cmd}}

Returns startup command.

## docker logs

Retrieves logs.

## 2>&1

Redirects STDERR to STDOUT.

## tail -5

Returns last five log lines.

---

# Real-World DevOps Workflow

```text
Alert Received
      |
      v
Container Failure
      |
      v
Check Status
      |
      v
Check Logs
      |
      v
Check Exit Code
      |
      v
Inspect Metadata
      |
      v
Identify Root Cause
      |
      v
Fix Configuration
      |
      v
Rebuild Image
      |
      v
Redeploy Service
      |
      v
Verify Recovery
```

# Skills Practiced

- Multi-Stage Docker Builds
- Docker Images
- Docker Containers
- Docker Logs
- Docker Inspect
- Exit Code Analysis
- Root Cause Investigation
- Bash Variables
- Bash Loops
- Command Substitution
- Linux Redirection
- Automated Reporting
- Dynamic Container Discovery
- DevOps Troubleshooting

# Project Outcome

Successfully:

- Built a Multi-Stage Docker Image
- Created an Intentionally Failed Container
- Investigated Failure Using Docker Logs
- Analyzed Metadata Using Docker Inspect
- Identified Exit Code 127
- Fixed Container Startup Configuration
- Rebuilt and Redeployed the Application
- Automated Investigation of All Containers
- Generated Dynamic Investigation Reports

This project simulates a real-world DevOps troubleshooting workflow used to investigate failed containers, identify root causes, automate diagnostics, and restore services.
