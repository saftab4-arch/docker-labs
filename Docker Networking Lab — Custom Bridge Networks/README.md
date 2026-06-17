Docker Networking Lab — Custom Bridge Networks

Overview

This lab demonstrates Docker container networking using custom bridge networks. Two real-world scenarios are covered:


Scenario 1 — Create containers already attached to a custom network from the start
Scenario 2 — Connect already-running containers to a custom network at runtime


Both scenarios prove that containers on a custom bridge network can communicate with each other by name using Docker's built-in DNS — something the default bridge network does NOT support.


Key Concepts

Network TypeDNS by NameUse CaseDefault bridge❌ NoBasic container isolationCustom bridge✅ YesMulti-container apps, microservicesHostN/AContainer shares host networkNone❌ Fully isolatedMaximum security, no network


Scenario 1 — Create Containers WITH Network from the Start

Step 1 — Create Custom Network

bashdocker network create devops-net
docker network ls

Creates a new custom bridge network. Docker assigns a subnet automatically (172.18.0.0/16).

Step 2 — Run Both Containers on the Same Network

bashdocker run -d \
  --name web1 \
  --network devops-net \
  nginx

docker run -d \
  --name web2 \
  --network devops-net \
  nginx

docker ps

Both containers are created already attached to devops-net. They get IPs from the same subnet.

Step 3 — Verify Network (Both Containers Listed)

bashdocker inspect devops-net

Output shows both web1 and web2 in the Containers section with their assigned IPs:

web1 → 172.18.0.2
web2 → 172.18.0.3

Step 4 — Test Connectivity with curl

bashdocker exec -it web1 sh
apt update && apt install curl -y
curl http://web2

Result: web1 successfully retrieves nginx HTML from web2 by name — no IP address needed. Docker DNS handles the resolution automatically.


Scenario 2 — Connect Already-Running Containers to Network

Step 1 — Run Containers WITHOUT Custom Network

bashdocker run -d --name container1 nginx
docker run -d --name container2 nginx
docker ps

Containers are running on the default bridge network. No custom network attached.

Step 2 — Prove They CANNOT Talk by Name

bashdocker exec -it container1 bash
apt-get update && apt-get install -y iputils-ping
ping container2

Result:

ping: container2: Temporary failure in name resolution

Default bridge has no DNS. Containers cannot find each other by name.

Step 3 — Create Network and Connect Running Containers

bashdocker network create mynetwork

# Connect BOTH running containers without stopping them
docker network connect mynetwork container1
docker network connect mynetwork container2

# Verify both are on the network
docker network inspect mynetwork

No need to recreate containers. docker network connect works on running containers instantly.

Step 4 — Prove They CAN Now Talk by Name

bashdocker exec -it container1 bash
ping container2

Result:

PING container2 (172.19.0.3) 56(84) bytes of data.
64 bytes from container2.mynetwork (172.19.0.3): icmp_seq=1 ttl=64 time=2.74 ms
64 bytes from container2.mynetwork (172.19.0.3): icmp_seq=2 ttl=64 time=0.064 ms
6 packets transmitted, 6 received, 0% packet loss

Docker DNS now resolves container2 to its IP automatically. 0% packet loss.


Bonus — Isolated Container (--network none)

bashdocker run -d \
  --name isolated-container \
  --network none \
  nginx

docker inspect isolated-container | grep NetworkMode

Result:

"NetworkMode": "none"

Container has zero network access. Cannot reach anything, cannot be reached. Used for maximum security workloads.


Inspect Network Details

bash# Full network details
docker inspect devops-net

# Container network settings
docker inspect pg-lab-2

docker inspect shows full JSON including:


Subnet and Gateway
Each container's IP address
MAC address
Network mode



Key Commands Summary

bash# Create network
docker network create mynetwork

# List all networks
docker network ls

# Connect running container to network
docker network connect mynetwork container1

# Disconnect container from network
docker network disconnect mynetwork container1

# Inspect network (see all connected containers)
docker network inspect mynetwork

# Delete network
docker network rm mynetwork

# Run container on specific network from start
docker run -d --name web1 --network mynetwork nginx


What This Proves

Default bridge    → containers cannot find each other by name
Custom bridge     → Docker DNS resolves container names automatically
--network none    → complete network isolation
Runtime connect   → no need to recreate containers to change networks

This is the foundation of how Docker Compose works internally — every service in a compose file gets placed on a shared custom network automatically, which is why Flask can reach Postgres by typing db:5432 instead of an IP address.
