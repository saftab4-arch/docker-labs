# Project - Docker Named Volumes & PostgreSQL Data Persistence Lab

## Project Overview

This project demonstrates how Docker Named Volumes provide persistent storage for stateful applications such as PostgreSQL.

The goal was to:

1. Create a Docker Named Volume
2. Deploy a PostgreSQL Container
3. Store Database Data Inside the Volume
4. Create Databases and Tables
5. Insert Data
6. Delete the Container
7. Recreate the Container
8. Verify Data Persistence

This is a core DevOps concept used for:

- PostgreSQL
- MySQL
- MariaDB
- MongoDB
- Jenkins
- Grafana
- SonarQube
- GitLab
- Prometheus

---

# Architecture

```text
Docker Host
│
├── Docker Volume
│   └── pg-lab-data
│
└── PostgreSQL Container
    └── /var/lib/postgresql
            │
            └── Database Files
                    │
                    ├── companydb
                    └── employees table
```

---

# Why Named Volumes?

Containers are temporary.

If a container is deleted:

```text
Container = Gone
Data = Gone
```

unless the data is stored externally.

Docker Volumes provide:

- Persistent Storage
- Better Performance
- Easier Backups
- Cleaner Container Lifecycle

---

# Step 1 - Create Docker Volume

Create a named volume:

```bash
docker volume create pg-lab-data
```

Verify:

```bash
docker volume ls
```

Example:

```text
DRIVER    VOLUME NAME
local     pg-lab-data
```

---

# Step 2 - Inspect Volume

```bash
docker volume inspect pg-lab-data
```

Example Output:

```json
[
  {
    "Name": "pg-lab-data",
    "Driver": "local",
    "Mountpoint": "/var/lib/docker/volumes/pg-lab-data/_data"
  }
]
```

Important:

Docker automatically manages this storage location.

No manual folder creation is required.

---

# Step 3 - Create Environment File

Create:

```bash
nano postgres.env
```

Contents:

```text
POSTGRES_PASSWORD=test123
```

Verify:

```bash
cat postgres.env
```

---

# Why Use Environment Files?

Instead of:

```bash
-e POSTGRES_PASSWORD=test123
```

which exposes credentials in command history,

use:

```bash
--env-file postgres.env
```

Benefits:

- Cleaner
- More Secure
- Easier Automation
- Production Friendly

---

# Step 4 - Create PostgreSQL Container

```bash
docker run -d \
--name pg-lab-1 \
--env-file postgres.env \
-v pg-lab-data:/var/lib/postgresql \
-p 5444:5432 \
postgres
```

---

# Understanding Every Flag

## docker run

Creates and starts a container.

---

## -d

Detached Mode.

Runs container in background.

Without:

```bash
-d
```

terminal remains attached.

---

## --name

Assign container name.

```bash
--name pg-lab-1
```

instead of random container names.

---

## --env-file

Loads environment variables.

```bash
--env-file postgres.env
```

Equivalent to:

```bash
-e POSTGRES_PASSWORD=test123
```

---

## -v

Mount volume.

```bash
-v pg-lab-data:/var/lib/postgresql
```

Format:

```bash
-v volume-name:container-path
```

Docker manages storage automatically.

---

## -p

Port Mapping.

```bash
-p 5444:5432
```

Meaning:

```text
Host Port      Container Port
5444     -->       5432
```

Users connect to:

```text
localhost:5444
```

Container receives traffic on:

```text
5432
```

---

## postgres

Image name.

Docker pulls image if not present locally.

---

# Step 5 - Verify Container

```bash
docker ps
```

Example:

```text
pg-lab-1
Up
0.0.0.0:5444->5432/tcp
```

---

# Step 6 - Connect to PostgreSQL

```bash
docker exec -it pg-lab-1 psql -U postgres
```

---

# Understanding Every Flag

## docker exec

Execute command inside running container.

---

## -it

Interactive Terminal.

Combination of:

```bash
-i
```

Keep STDIN open.

and

```bash
-t
```

Allocate terminal.

---

## psql

PostgreSQL CLI client.

---

## -U

Specify PostgreSQL user.

```bash
-U postgres
```

Connect as postgres user.

---

# PostgreSQL Commands Used

---

## List Databases

```sql
\l
```

Output:

```text
postgres
template0
template1
```

---

## Create Database

```sql
CREATE DATABASE companydb;
```

---

## Connect to Database

```sql
\c companydb
```

Output:

```text
You are now connected to database "companydb"
```

---

## Create Table

```sql
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100)
);
```

---

# Understanding Table Definition

## SERIAL

Auto increment integer.

Example:

```text
1
2
3
4
```

---

## PRIMARY KEY

Unique row identifier.

No duplicates allowed.

---

## VARCHAR(100)

String column.

Maximum length:

```text
100 characters
```

---

# Insert Data

```sql
INSERT INTO employees(name)
VALUES ('Basit');
```

Output:

```text
INSERT 0 1
```

Meaning:

```text
1 row inserted
```

---

# Query Data

```sql
SELECT * FROM employees;
```

Output:

```text
 id | name
----+-------
 1  | Basit
```

---

# Verify Tables

```sql
\dt
```

Output:

```text
employees
```

---

# Exit PostgreSQL

```sql
\q
```

---

# Step 7 - Stop Container

```bash
docker stop pg-lab-1
```

---

# Step 8 - Remove Container

```bash
docker rm pg-lab-1
```

Verify:

```bash
docker ps -a
```

Container should be gone.

---

# Step 9 - Verify Volume Still Exists

```bash
docker volume ls
```

Output:

```text
pg-lab-data
```

Important:

Container deleted.

Volume remains.

---

# Step 10 - Create New Container Using Same Volume

```bash
docker run -d \
--name pg-lab-2 \
--env-file postgres.env \
-v pg-lab-data:/var/lib/postgresql \
-p 5444:5432 \
postgres
```

---

# Step 11 - Reconnect to PostgreSQL

```bash
docker exec -it pg-lab-2 psql -U postgres
```

---

# Step 12 - Verify Persistence

List databases:

```sql
\l
```

Output:

```text
companydb
```

Database survived.

---

Connect:

```sql
\c companydb
```

Verify table:

```sql
\dt
```

Output:

```text
employees
```

Table survived.

---

Verify data:

```sql
SELECT * FROM employees;
```

Output:

```text
 id | name
----+-------
 1  | Basit
```

Data survived.

---

# Named Volume vs Bind Mount

## Named Volume

```bash
-v pg-lab-data:/var/lib/postgresql
```

Docker manages storage.

Best for:

- Databases
- Jenkins
- Grafana
- Prometheus

Advantages:

- Portable
- Cleaner
- Safer
- Production Standard

---

## Bind Mount

```bash
-v /home/user/data:/data
```

User manages storage.

Best for:

- Application Files
- Config Files
- Development Workflows

Advantages:

- Easy access from host
- Easy editing

---

# Important Docker Commands Learned

List Containers:

```bash
docker ps
```

---

List All Containers:

```bash
docker ps -a
```

---

List Images:

```bash
docker images
```

---

List Volumes:

```bash
docker volume ls
```

---

Inspect Volume:

```bash
docker volume inspect pg-lab-data
```

---

View Logs:

```bash
docker logs pg-lab-1
```

---

Stop Container:

```bash
docker stop pg-lab-1
```

---

Delete Container:

```bash
docker rm pg-lab-1
```

---

Delete Volume:

```bash
docker volume rm pg-lab-data
```

---

# Skills Practiced

- Docker Volumes
- Docker Storage Management
- PostgreSQL Containers
- Environment Variables
- Container Networking
- Database Administration
- SQL Basics
- Data Persistence
- Volume Inspection
- Container Lifecycle Management

---

# Project Outcome

Successfully:

- Created Docker Named Volume
- Deployed PostgreSQL Container
- Stored Database Files Inside Volume
- Created Database and Tables
- Inserted Data
- Deleted Container
- Recreated Container
- Verified Data Persistence

This project demonstrates one of the most important concepts in containerized infrastructure:

```text
Container = Temporary

Volume = Persistent
```

The container can be destroyed and recreated at any time, while the data remains safely stored inside the Docker volume.
