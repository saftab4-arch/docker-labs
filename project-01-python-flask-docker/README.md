# Project 01 – Python Flask Application Dockerization

## Overview

This project demonstrates the complete Docker workflow used by DevOps Engineers to containerize an application.

The objective was to:

- Create a Python Flask application
- Write a Dockerfile
- Build a Docker Image
- Create a Docker Container
- Publish application ports
- Access the application through a web browser
- Verify application execution inside the container

This project simulates a common DevOps task where developers provide application code and the DevOps Engineer creates the containerization configuration required to deploy the application consistently across environments.

---

# Architecture

```text
Python Flask Application
            │
            ▼
       Dockerfile
            │
            ▼
      Docker Image
            │
            ▼
    Docker Container
            │
            ▼
     localhost:5000
```

---

# Project Structure

```text
project-01-python-flask-docker/
│
├── app.py
├── requirements.txt
├── Dockerfile
└── README.md
```

---

# Application Code

## app.py

```python
from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return "Hello from Docker Flask App!"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
```

### Explanation

Creates a simple Flask web server.

Route:

```text
/
```

Response:

```text
Hello from Docker Flask App!
```

Application listens on:

```text
0.0.0.0:5000
```

Allowing Docker to expose the service externally.

---

# Dependencies

## requirements.txt

```text
flask
```

Used by pip to install required Python packages.

---

# Dockerfile

```dockerfile
FROM python:3.12

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY . .

EXPOSE 5000

CMD ["python", "app.py"]
```

---

# Dockerfile Breakdown

## Step 1 – Base Image

```dockerfile
FROM python:3.12
```

Downloads and uses the official Python 3.12 Docker image.

Provides:

- Linux environment
- Python runtime
- pip package manager

---

## Step 2 – Working Directory

```dockerfile
WORKDIR /app
```

Creates and switches into:

```text
/app
```

Equivalent to:

```bash
cd /app
```

All future commands execute inside this directory.

---

## Step 3 – Copy Dependency File

```dockerfile
COPY requirements.txt .
```

Copies:

```text
Host Machine
requirements.txt
```

into:

```text
Container Image
/app/requirements.txt
```

---

## Step 4 – Install Dependencies

```dockerfile
RUN pip install -r requirements.txt
```

Installs Flask inside the image.

Equivalent command:

```bash
pip install -r requirements.txt
```

---

## Step 5 – Copy Application Files

```dockerfile
COPY . .
```

Copies project files into the image.

Files copied:

```text
app.py
requirements.txt
README.md
Dockerfile
```

Destination:

```text
/app
```

---

## Step 6 – Expose Port

```dockerfile
EXPOSE 5000
```

Documents that the application listens on:

```text
Port 5000
```

---

## Step 7 – Start Application

```dockerfile
CMD ["python", "app.py"]
```

Executed automatically when the container starts.

Equivalent command:

```bash
python app.py
```

---

# Build Docker Image

## Command

```bash
docker build -t flask-demo .
```

### Breakdown

```bash
docker build
```

Build image from Dockerfile.

```bash
-t
```

Assign image tag/name.

```bash
flask-demo
```

Image name.

```bash
.
```

Current directory contains Dockerfile.

---

# Verify Image Creation

```bash
docker images
```

Example:

```text
REPOSITORY     TAG
flask-demo     latest
```

---

# Create Docker Container

## Command

```bash
docker run -d --name flask-app -p 5000:5000 flask-demo
```

### Breakdown

```bash
-d
```

Run container in background.

```bash
--name flask-app
```

Container name.

```bash
-p 5000:5000
```

Port mapping:

```text
Host Port      Container Port
5000      ->      5000
```

```bash
flask-demo
```

Image used to create the container.

---

# Verify Running Container

```bash
docker ps
```

Example:

```text
CONTAINER ID   IMAGE        STATUS
xxxxx          flask-demo   Up
```

---

# Access Application

Open browser:

```text
http://localhost:5000
```

Expected output:

```text
Hello from Docker Flask App!
```

---

# Enter Running Container

```bash
docker exec -it flask-app bash
```

Verify:

```bash
pwd
```

Output:

```text
/app
```

List files:

```bash
ls
```

Output:

```text
Dockerfile
README.md
app.py
requirements.txt
```

---

# Useful Docker Commands

## List Images

```bash
docker images
## List Running Containers

```bash
docker ps
```

## List All Containers

```bash
docker ps -a
```

## Stop Container

```bash
docker stop flask-app
```

## Start Container

```bash
docker start flask-app
```

## Remove Container

```bash
docker rm flask-app
```

## Remove Image

```bash
docker rmi flask-demo
```

---

# Skills Demonstrated

- Docker
- Containerization
- Dockerfile Authoring
- Python Flask
- Image Building
- Container Management
- Port Mapping
- Container Verification
- Linux Commands
- DevOps Fundamentals

---

# Key Learning Outcomes

During this project I learned:

- Difference between Docker Image and Docker Container
- How Dockerfiles are used to build images
- Why dependency files are copied separately
- How Docker layer caching improves build performance
- How ports are exposed and mapped
- How to enter and inspect running containers
- Complete application deployment workflow using Docker

---

# End-to-End Workflow

```text
Create Flask App
        │
        ▼
Create Dockerfile
        │
        ▼
Build Docker Image
        │
        ▼
Verify Image
        │
        ▼
Create Container
        │
        ▼
Publish Port
        │
        ▼
Access Application
        │
        ▼
Inspect Container
        │
        ▼
Project Complete
```
