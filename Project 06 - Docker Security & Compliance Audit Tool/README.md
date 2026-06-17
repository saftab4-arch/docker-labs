Project 06 - Docker Security & Compliance Audit
Tool
Overview
This project simulates a real-world Docker environment consisting of multiple containers managed by
Docker Compose. It demonstrates container networking, persistent storage with named volumes,
PostgreSQL database services, an audit container, and a custom Docker security auditing script.
The environment contains:
Nginx Web Server
PostgreSQL Database
Ubuntu Audit Container
Custom Bridge Network
Named Docker Volumes
Automated Security Audit Script
Docker Compose Deployment
Architecture
                    security-net
                172.18.0.0/16 bridge
─────────────────────────────────────────
                audit-tool
                 Ubuntu
              172.18.0.2
                    │
         ┌──────────┴──────────┐
         │                     │
         ▼                     ▼
        nginx               postgres
     172.18.0.3           172.18.0.4
        │                     │
        ▼                     ▼
   nginx-logs             postgres-data
      volume                 volume
• 
• 
• 
• 
• 
• 
• 
1
audit-data volume
│
▼
docker-security-audit.sh
reports/
docker-audit-yyyy-mm-dd.txt
Technologies Used
• 
• 
• 
• 
• 
• 
• 
• 
Docker
Docker Compose
Nginx
PostgreSQL
Ubuntu
Bash
Custom Bridge Networks
Named Volumes
Project Structure
project-06-docker-security-audit
│
├── docker-compose.yml
├── docker-security-audit.sh
├── postgres.env
├── README.md
└── reports/
Custom Network
Created manually:
docker network create security-net
2
Verify:
docker network ls
Named Volumes
Created manually:
docker volume create postgres-data
docker volume create nginx-logs
docker volume create audit-data
Verify:
docker volume ls
Docker Compose Configuration
services:
nginx:
image: nginx
container_name: nginx
ports:- "8080:80"
networks:- security-net
volumes:- nginx-logs:/var/log/nginx
postgres:
image: postgres
container_name: postgres
ports:- "5432:5432"
environment:
POSTGRES_USER: postgres
POSTGRES_PASSWORD: StrongPassword123
3
POSTGRES_DB: companydb
networks:- security-net
volumes:- postgres-data:/var/lib/postgresql
audit-tool:
image: ubuntu
container_name: audit-tool
command: sleep infinity
networks:- security-net
volumes:- audit-data:/reports
networks:
security-net:
external: true
volumes:
postgres-data:
external: true
nginx-logs:
external: true
audit-data:
external: true
YAML Explanation
image
Specifies which image to pull.
Example:
image: nginx
Equivalent:
4
docker run nginx
container_name
Assigns a friendly name.
container_name: postgres
ports
Maps host ports to container ports.
ports:- "8080:80"
Meaning:
Host 8080 → Container 80
environment
Creates environment variables inside the container.
environment:
POSTGRES_USER: postgres
Equivalent:-e POSTGRES_USER=postgres
5
networks
Connects the container to a custom network.
networks:- security-net
Equivalent:--network security-net
volumes
Maps persistent Docker volumes.
volumes:- postgres-data:/var/lib/postgresql
Meaning:
Docker Volume
↓
postgres-data
↓
Container Path
/var/lib/postgresql
external: true
Tells Docker Compose not to create the volume or network. Use existing resources instead.
Start Environment
docker compose up-d
6
Verify:
docker ps
Container Connectivity Testing
Enter audit container:
docker exec-it audit-tool bash
Install ping:
apt update
apt install iputils-ping-y
Test communication:
ping nginx
ping postgres
Docker DNS automatically resolves container names.
HTTP Connectivity Test
Install curl:
apt install curl-y
Test:
curl http://nginx
Returned:
7
Welcome to nginx!
PostgreSQL Connectivity Test
Install PostgreSQL client:
apt install postgresql-client-y
Connect:
psql-h postgres-U postgres
List databases:
\l
Output:
companydb
postgres
template0
template1
Docker Security Audit Script
Run:
./docker-security-audit.sh
Creates:
reports/docker-audit-yyyy-mm-dd.txt
8
Script Audits
Running Containers
docker ps
Images
docker images
Networks
docker network ls
docker network inspect security-net
Volumes
docker volume ls
Resource Usage
docker stats--no-stream
Port Exposure
docker ps--format
Container Configuration
docker inspect nginx
docker inspect postgres
docker inspect audit-tool
9
Troubleshooting
Container exits immediately
Keep Ubuntu container alive:
command: sleep infinity
Docker Desktop Virtualization Error
Enable:
• 
• 
• 
• 
Intel VT-x / AMD-V
Virtual Machine Platform
Windows Hypervisor Platform
Windows Subsystem for Linux
Restart WSL:
wsl--shutdown
Verify:
wsl--status
Expected:
Default Version: 2
Verify Network
docker network inspect security-net
10
Verify Volumes
docker volume inspect postgres-data
Resume Project Description
Docker Security & Compliance Audit Tool
• 
• 
• 
• 
• 
Built a multi-container Docker environment using Docker Compose with Nginx, PostgreSQL, and
Ubuntu audit containers.
Implemented custom bridge networking and persistent named volumes.
Developed a Bash-based Docker security audit tool generating timestamped compliance reports.
Validated container-to-container communication using Docker DNS, ping, curl, and PostgreSQL client
connectivity.
Performed container inspection, resource monitoring, network auditing, and port exposure analysis.
Skills Demonstrated
• 
• 
• 
• 
• 
• 
• 
• 
• 
• 
• 
• 
• 
• 
• 
Docker
Docker Compose
Container Networking
Docker DNS
Named Volumes
Bash Scripting
PostgreSQL
Nginx
Linux
Container Security
Resource Monitoring
Infrastructure as Code
Troubleshooting
DevOps Fundamentals
SRE Concepts
This project simulates a small production environment and demonstrates many tasks performed by DevOps
Engineers, Platform Engineers, and Site Reliability Engineers during container deployment, auditing, and
troubleshooting.
11
