# Docker Volumes Lab – Data Persistence with Bind Mounts

## Overview

This lab demonstrates how Docker volumes work by mounting a host directory into a container and verifying that data persists even after containers are deleted.

The goal was to understand:

- Container storage vs persistent storage
- Bind mounts
- Docker volume concepts
- Data persistence across container recreation
- Working with Docker from WSL Ubuntu

---

# Environment

OS: Ubuntu 24.04 (WSL)

Editor: VS Code

Container Runtime: Docker Desktop + WSL Integration

Image: react-multistage:v1

---

# Lab Architecture

```text
Ubuntu Host

/home/syedaftab04/docker-labs/volumes/data
                │
                │ Mounted
                ▼
Docker Container
/tmp
```

Files created in either location become visible in both places.

---

# Step 1 – Create Host Directory

Navigate to the data directory:

```bash
cd ~/docker-labs/volumes/data
```

Verify location:

```bash
pwd
```

Output:

```text
/home/syedaftab04/docker-labs/volumes/data
```

---

# Step 2 – Create Host File

Create a test file:

```bash
echo "Gante ka king Zimbu" > hello.txt
```

Verify:

```bash
cat hello.txt
```

Output:

```text
Gante ka king Zimbu
```

---

# Step 3 – Run Container with Bind Mount

Start a container and mount the host directory to `/tmp` inside the container:

```bash
docker run -d \
-p 8082:80 \
-v /home/syedaftab04/docker-labs/volumes/data:/tmp \
--name volume-demo3 \
react-multistage:v1
```

Explanation:

```text
-v HOST_PATH:CONTAINER_PATH

Host:
  /home/syedaftab04/docker-labs/volumes/data

Container:
  /tmp
```

---

# Step 4 – Verify Mount Inside Container

Connect to the container:

```bash
docker exec -it volume-demo3 sh
```

Navigate to the mounted directory:

```bash
cd /tmp
```

List files:

```bash
ls
```

Output:

```text
hello.txt
```

Read file:

```bash
cat hello.txt
```

Output:

```text
Gante ka king Zimbu
```

This proves the container can access files stored on the host.

---

# Step 5 – Demonstrate Persistence

Stop and remove the container:

```bash
docker stop volume-demo3

docker rm volume-demo3
```

Verify container removal:

```bash
docker ps
```

---

# Step 6 – Create New Container

Create a brand-new container using the same bind mount:

```bash
docker run -d \
-p 8082:80 \
-v /home/syedaftab04/docker-labs/volumes/data:/tmp \
--name volume-demo4 \
react-multistage:v1
```

---

# Step 7 – Verify Data Exists

Enter the new container:

```bash
docker exec -it volume-demo4 sh
```

Navigate to mounted directory:

```bash
cd /tmp
```

List files:

```bash
ls
```

Output:

```text
hello.txt
```

Read file:

```bash
cat hello.txt
```

Output:

```text
Gante ka king Zimbu
```

Success.

The file still exists even though the original container was deleted.

---

# What Happened?

Without a volume:

```text
Container
└── hello.txt

Delete Container
└── File Lost
```

With a bind mount:

```text
Host Directory
└── hello.txt

        ▲
        │
        │ Mounted
        ▼

Container
└── /tmp/hello.txt
```

Deleting the container does not affect the host file.

---

# Troubleshooting Encountered

## Port Already Allocated

Error:

```text
Bind for 0.0.0.0:8080 failed:
port is already allocated
```

Cause:

Another container was already using port 8080.

Resolution:

Use a different host port:

```bash
-p 8082:80
```

---

## Container Name Already Exists

Error:

```text
container name is already in use
```

Cause:

Docker container names must be unique.

Resolution:

Use a new name:

```bash
--name volume-demo4
```

or remove the old container:

```bash
docker rm volume-demo3
```

---

## Bash Not Found

Error:

```text
exec: "bash": executable file not found
```

Cause:

The nginx:alpine image does not include Bash.

Resolution:

Use:

```bash
docker exec -it volume-demo3 sh
```

instead.

---

# Key Commands Used

## View Running Containers

```bash
docker ps
```

## View All Containers

```bash
docker ps -a
```

## Start Container

```bash
docker run
```

## Connect to Container

```bash
docker exec -it CONTAINER sh
```

## Stop Container

```bash
docker stop CONTAINER
```

## Remove Container

```bash
docker rm CONTAINER
```

## View Logs

```bash
docker logs CONTAINER
```

---

# Key Concepts Learned

- Docker Bind Mounts
- Persistent Storage
- Host vs Container Filesystems
- Container Lifecycle
- Docker Networking and Port Mapping
- Volume Persistence
- Docker Troubleshooting
- WSL Ubuntu Development Environment

---

# Real World Example

Without volumes:

```text
MySQL Container
└── Database Files

Delete Container
└── Database Lost
```

With volumes:

```text
Ubuntu Server
└── /var/lib/mysql-data

        ▲
        │ Mounted
        ▼

MySQL Container
└── /var/lib/mysql
```

Delete the container:

```text
Container Deleted ❌
Database Still Exists ✅
```

This is how databases, Jenkins, Grafana, Prometheus, and many Kubernetes workloads preserve data.

---

# Outcome

Successfully demonstrated Docker volume persistence by mounting a host directory into a container, deleting the container, recreating it, and verifying that data remained available across container lifecycles.

---

## Skills Demonstrated

- Docker
- Docker Volumes
- Bind Mounts
- Linux File Systems
- WSL Ubuntu
- VS Code
- Container Lifecycle Management
- Troubleshooting Docker Containers
- Persistent Storage Concepts

---

## Author

**Syed Aftab**

Docker Learning Series

Cloud Operations Lab
