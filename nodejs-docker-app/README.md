# Project 02 - Node.js Dockerization

## Overview

This project demonstrates how to containerize a simple Node.js web application using Docker.

The application runs a lightweight HTTP server that listens on port 3000 and returns a simple text response.

---

## Project Structure

```text
.
├── app.js
├── package.json
├── Dockerfile
└── README.md
```

---

## Application Code

The application uses Node.js built-in HTTP module to create a web server.

Endpoint:

```text
http://localhost:3000
```

Response:

```text
Hello from Dockerized Node.js Application!
```

---

## Dockerfile

```dockerfile
FROM node:24

WORKDIR /app

COPY package.json .

RUN npm install

COPY . .

EXPOSE 3000

CMD ["npm","start"]
```

---

## Build Docker Image

```bash
docker build -t nodejs-demo:v1 .
```

Verify image:

```bash
docker images
```

---

## Run Container

```bash
docker run -d \
--name nodejs-container \
-p 3000:3000 \
nodejs-demo:v1
```

Verify running container:

```bash
docker ps
```

---

## View Container Logs

```bash
docker logs nodejs-container
```

Example output:

```text
Server running on port 3000
```

---

## Access Application

```bash
curl localhost:3000
```

Expected output:

```text
Hello from Dockerized Node.js Application!
```

---

## Container Inspection

Access the running container:

```bash
docker exec -it nodejs-container sh
```

List application files:

```bash
ls
```

Expected:

```text
Dockerfile
app.js
package-lock.json
package.json
```

---

## Skills Demonstrated

- Docker Image Creation
- Dockerfile Development
- Container Lifecycle Management
- Port Mapping
- Log Inspection
- Container Troubleshooting
- Node.js Application Containerization

---

## Author

Syed Aftab

Cloud / DevOps Engineering Portfolio Project
