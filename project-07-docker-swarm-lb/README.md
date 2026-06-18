# Project 07 - Docker Swarm Load Balancer Lab

## Overview

This project demonstrates Docker Swarm fundamentals, service orchestration, auto-healing, scaling, overlay networking, stack deployment, and load balancing with Nginx.

Unlike Docker Compose, Docker Swarm provides clustering, desired state management, self-healing, and scaling capabilities.

---

# Architecture

```
                 localhost:8080
                        |
                +----------------+
                |   nginx-lb      |
                |   (1 replica)   |
                +----------------+
                         |
                  project07_web
                         |
     -------------------------------------------------
     |             |             |          |         |
 web.1         web.2         web.3      web.4     web.5
 nginx         nginx         nginx      nginx     nginx
```

---

# Initialize Docker Swarm

Create a swarm cluster:

```bash
docker swarm init
```

Verify:

```bash
docker info
```

Look for:

```
Swarm: active
```

---

# Create Overlay Network

```bash
docker network create \
--driver overlay \
swarm-net
```

Verify:

```bash
docker network ls
```

Output:

```
swarm-net    overlay    swarm
```

---

# Create First Service

Create an nginx service with 3 replicas:

```bash
docker service create \
--name web \
--replicas 3 \
nginx
```

Verify:

```bash
docker service ls
```

Example:

```
NAME  MODE        REPLICAS
web   replicated  3/3
```

---

# View Tasks

```bash
docker service ps web
```

Example:

```
web.1
web.2
web.3
```

A task represents desired work.

Each task creates one container.

Relationship:

```
Node
 ↓
Service
 ↓
Task
 ↓
Container
```

---

# View Containers

```bash
docker ps
```

Example:

```
web.1
web.2
web.3
```

---

# Auto-Healing Test

Kill one container:

```bash
docker rm -f <container-id>
```

Observe:

```bash
docker service ps web
```

Docker Swarm automatically creates a replacement container.

Desired state:

```
3 replicas
```

Current state:

```
3 replicas
```

Swarm continuously maintains the desired state.

---

# Scale Service

Increase replicas:

```bash
docker service scale web=5
```

Verify:

```bash
docker service ls
```

Result:

```
web    5/5
```

View tasks:

```bash
docker service ps web
```

View containers:

```bash
docker ps
```

---

# Docker Compose vs Docker Swarm

Docker Compose:

```bash
docker compose up -d
```

Purpose:

* Single host
* Starts containers
* No auto-healing
* No scheduler
* No cluster

Docker Swarm:

```bash
docker service create
```

Purpose:

* Multi-node cluster
* Desired state management
* Auto-healing
* Scheduling
* Load balancing
* High availability

---

# Stack Deployment

Create:

```bash
docker-stack.yml
```

Deploy:

```bash
docker stack deploy -c docker-stack.yml project07
```

Explanation:

### -c

Specifies compose file.

Example:

```bash
-c docker-stack.yml
```

### project07

Stack name.

Services become:

```
project07_web
project07_nginx-lb
```

---

# Service Names

View services:

```bash
docker service ls
```

Example:

```
project07_web
project07_nginx-lb
```

View tasks:

```bash
docker service ps project07_web
```

---

# Nginx Load Balancer

Create:

```bash
nginx.conf
```

Contents:

```nginx
events {}

http {

    upstream backend {
        server project07_web:80;
    }

    server {

        listen 80;

        location / {

            proxy_pass http://backend;

        }
    }
}
```

Deploy load balancer:

```yaml
nginx-lb:

  image: nginx

  ports:
    - "8080:80"

  networks:
    - swarm-net

  volumes:
    - ./nginx.conf:/etc/nginx/nginx.conf:ro

  deploy:
    replicas: 1
```

---

# Port Mapping

```yaml
ports:
  - "8080:80"
```

Meaning:

```
Host:8080
      ↓
Container:80
```

Access:

```
http://localhost:8080
```

---

# Volume Mount

Read-only mount:

```yaml
volumes:
  - ./nginx.conf:/etc/nginx/nginx.conf:ro
```

Explanation:

```
Host file
    ↓
./nginx.conf

Mounted inside container
    ↓
/etc/nginx/nginx.conf

ro = read only
```

---

# Load Balancing Test

Enter each container:

```bash
docker exec -it <container> bash
```

Modify:

```bash
echo "<h1>WEB SERVER 1</h1>" > /usr/share/nginx/html/index.html
```

Repeat:

```
WEB SERVER 2
WEB SERVER 3
WEB SERVER 4
WEB SERVER 5
```

Continuous test:

```bash
while true; do
curl -s http://project07_web | grep h1
sleep 1
done
```

Output:

```
WEB SERVER 1
WEB SERVER 2
WEB SERVER 3
WEB SERVER 4
WEB SERVER 5
```

Demonstrates internal load balancing.

---

# Container Recovery Test

Kill container:

```bash
docker rm -f <container-id>
```

Watch:

```bash
docker service ps project07_web
```

Output:

```
Shutdown
Running
```

Swarm automatically replaces the failed task.

Desired state remains:

```
5/5
```

---

# Persistent Volumes

Create volume:

```bash
docker volume create audit-data
```

Attach:

```yaml
volumes:

  - audit-data:/audit-data
```

Purpose:

* Data survives container recreation.
* Storage separated from container lifecycle.

---

# Unprivileged Nginx Image

Changed image:

```yaml
image: nginxinc/nginx-unprivileged:latest
```

Benefit:

* Containers do not run as root.
* Improved security.
* Principle of least privilege.

Observation:

Attempting to write:

```bash
echo hello > /audit-data/test.txt
```

Result:

```
Permission denied
```

This demonstrated why custom Dockerfiles and proper ownership are required.

---

# Commands Used

Initialize swarm:

```bash
docker swarm init
```

Create network:

```bash
docker network create --driver overlay swarm-net
```

Create service:

```bash
docker service create --name web --replicas 3 nginx
```

Scale:

```bash
docker service scale web=5
```

List services:

```bash
docker service ls
```

View tasks:

```bash
docker service ps project07_web
```

View containers:

```bash
docker ps
```

Enter container:

```bash
docker exec -it <container> bash
```

Remove container:

```bash
docker rm -f <container>
```

Deploy stack:

```bash
docker stack deploy -c docker-stack.yml project07
```

View networks:

```bash
docker network ls
```

View volumes:

```bash
docker volume ls
```

---

# Lessons Learned

* Service defines desired state.
* Tasks execute desired work.
* Tasks create containers.
* Containers are disposable.
* Swarm automatically heals failures.
* Scaling is declarative.
* Overlay networks enable service discovery.
* Stack deployment resembles Docker Compose but adds orchestration.
* Nginx can act as a reverse proxy and load balancer.
* Persistent data should reside in volumes.
* Containers should run as non-root whenever possible.
* Docker Swarm provides clustering and self-healing capabilities absent in Docker Compose.

---

# Future Improvements

* Deploy on AWS EC2 Manager + Worker nodes.
* Create custom Dockerfile with non-root user.
* Configure proper volume permissions.
* Add PostgreSQL service.
* Add audit.sh service.
* Multi-node persistent volumes.
* Node drain testing.
* Rolling updates.
* Secrets management.
* Health checks.
* Prometheus and Grafana monitoring.

---

Author: Syed Aftab

Project:

Project 07 - Docker Swarm Load Balancer Lab

Technologies:

* Docker
* Docker Swarm
* Nginx
* Overlay Networks
* Persistent Volumes
* YAML
* Linux
* Bash
