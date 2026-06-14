# Multi-Stage Docker Build with React, Vite, and Nginx

## Overview

This project demonstrates how to build and deploy a React/Vite application using a multi-stage Docker build.

The build process separates application compilation from runtime execution, resulting in a smaller and more secure production image.

Instead of shipping Node.js, npm, source code, and development dependencies to production, only the compiled application is copied into a lightweight Nginx container.

---

# Project Goals

* Learn multi-stage Docker builds
* Understand build vs runtime environments
* Reduce container image size
* Serve static content using Nginx
* Troubleshoot container startup failures
* Practice Docker operational workflows

---

# Architecture

```text
React Source Code
        │
        ▼
Node.js Build Stage
(npm install)
(npm run build)
        │
        ▼
dist/ Folder Generated
        │
        ▼
Nginx Runtime Stage
        │
        ▼
Application Served on Port 80
```

---

# Multi-Stage Dockerfile

```dockerfile
# Stage 1 - Build Application

FROM node:24 AS builder

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build


# Stage 2 - Runtime

FROM nginx:alpine

COPY --from=builder /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
```

---

# Understanding Each Stage

## Stage 1 - Build

The Node.js image is used to build the React/Vite application.

```dockerfile
FROM node:24 AS builder
```

Creates a build container.

```dockerfile
WORKDIR /app
```

Creates and switches into:

```text
/app
```

inside the container.

```dockerfile
COPY package*.json ./
```

Copies dependency files.

```dockerfile
RUN npm install
```

Installs project dependencies.

```dockerfile
COPY . .
```

Copies application source code.

```dockerfile
RUN npm run build
```

Generates:

```text
/app/dist
```

which contains the production-ready website.

---

## Stage 2 - Runtime

A lightweight Nginx container is used to serve the application.

```dockerfile
FROM nginx:alpine
```

Creates a clean runtime environment.

```dockerfile
COPY --from=builder /app/dist /usr/share/nginx/html
```

Copies the built application from the builder stage into Nginx's web root.

Nginx serves files from:

```text
/usr/share/nginx/html
```

---

# Build Process

Build the image:

```bash
docker build -f Dockerfile-multi-stage-build -t react-multistage:v1 .
```

Explanation:

```text
-f  = Specify Dockerfile
-t  = Tag image
.   = Current directory build context
```

---

# Verify Image

```bash
docker images
```

Expected:

```text
react-multistage   v1
```

---

# Run Container

```bash
docker run -d -p 8080:80 --name react-app react-multistage:v1
```

Explanation:

```text
8080 = Host Port
80   = Container Port
```

Access application:

```text
http://localhost:8080
```

---

# Testing

Check running containers:

```bash
docker ps
```

Check all containers:

```bash
docker ps -a
```

View logs:

```bash
docker logs react-app
```

Enter container:

```bash
docker exec -it react-app sh
```

Verify web content:

```bash
ls /usr/share/nginx/html
```

Expected:

```text
index.html
assets/
```

---

# Troubleshooting Performed

## Problem

Container exited immediately after startup.

Check:

```bash
docker ps -a
```

Result:

```text
Exited (1)
```

---

## Investigation

View logs:

```bash
docker logs react-app
```

Error:

```text
nginx: [emerg] unknown directive "deamon"
```

---

## Root Cause

Dockerfile contained:

```dockerfile
CMD ["nginx", "-g", "deamon off;"]
```

Incorrect spelling:

```text
deamon ❌
daemon ✅
```

---

## Fix

Updated command:

```dockerfile
CMD ["nginx", "-g", "daemon off;"]
```

Rebuilt image:

```bash
docker build -f Dockerfile-multi-stage-build -t react-multistage:v2 .
```

Redeployed container.

Application loaded successfully.

---

# Key Concepts Learned

## Multi-Stage Build

Build application in one stage and run application in another stage.

Benefits:

* Smaller images
* Reduced attack surface
* Faster deployments
* Cleaner production containers

---

## Build vs Runtime

Build Stage:

```text
Node.js
npm install
npm run build
```

Runtime Stage:

```text
Nginx
Static Website Files
```

---

## Why Nginx?

After:

```bash
npm run build
```

the application becomes:

```text
HTML
CSS
JavaScript
```

Only a web server is required.

Nginx efficiently serves static content without requiring Node.js.

---

# Skills Demonstrated

* Docker
* Multi-Stage Docker Builds
* React
* Vite
* Nginx
* Container Troubleshooting
* Docker Logs
* Container Inspection
* Linux CLI
* Build vs Runtime Architecture

---

# Author

Syed Aftab

Cloud Operations Lab
Docker Learning Series
