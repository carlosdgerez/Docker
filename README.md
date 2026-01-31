# Question2Answer (Q2A) – 3-Zone Docker Architecture

This project demonstrates a **multi-zone Docker Compose deployment** of the
**Question2Answer (Q2A)** application using **load balancing with round-robin**,
service isolation, and horizontal scaling.
**shared session handling via Redis**, service isolation, and horizontal scaling.
The Q2A image used is a **public image built and published by the author on Docker Hub**.

---

## Overview

This setup simulates a **real-world production-style architecture** using three logical network zones:

1. **Public Zone**
   - Exposes HTTP traffic to the host
   - Runs a reverse proxy / load balancer (Nginx)

2. **DMZ (Application Zone)**
   - Runs multiple replicas of the Q2A application
   - Scaled horizontally
   - Not directly exposed to the host

3. **Internal Zone**
   - Runs the MariaDB database
   - Only accessible from the application layer

---

## Architecture Diagram

```
                    ┌──────────────────────┐
                    │      Browser(s)      │
                    │  http://localhost    │
                    └──────────┬───────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │   Public Zone        │
                    │  Nginx Load Balancer │
                    │  (Round Robin)       │
                    └──────────┬───────────┘
                               │
             ┌─────────────────┼─────────────────┐
             │                 │                 │
             ▼                 ▼                 ▼
   ┌────────────────┐ ┌────────────────┐ ┌────────────────┐
   │   Q2A Replica  │ │   Q2A Replica  │ │   Q2A Replica  │
   │      #1        │ │      #2        │ │      #3        │
   │    (DMZ)       │ │    (DMZ)       │ │    (DMZ)       │
   └─────────┬──────┘ └─────────┬──────┘ └─────────┬──────┘
             │                  │                  │
             └──────────────────┼──────────────────┘
                                ▼
                     ┌──────────────────────┐
                     │   Internal Zone      │
                     │  Database + Redis    │
                     └──────────────────────┘
```

> When scaling the application, additional Q2A replicas are automatically
> included in the load balancer pool.

---

## How It Works

- The **Nginx proxy** distributes incoming HTTP requests using **round-robin**
- The `q2a` service can be scaled to any number of replicas
- Each replica connects to the same database in the internal network
- Docker’s internal DNS ensures service discovery
- No container uses a fixed `container_name` (required for scaling)

---
## Shared Sessions with Redis

PHP sessions are stored in Redis so users remain logged in even when requests
are handled by different containers.

```
session.save_handler = redis
session.save_path = "tcp://redis:6379"
```

---

## Shared Sessions with Redis

PHP sessions are stored in Redis so users remain logged in even when requests
are handled by different containers.

```
session.save_handler = redis
session.save_path = "tcp://redis:6379"
```

---

## Running the Stack

### Start the environment with 5 Q2A replicas

```bash
docker compose -f Zones-3.yaml up -d --scale q2a=5
```

This will:
- Start the database
- Start the load balancer
- Start **5 Q2A containers**
- Balance traffic automatically between them

---

## Testing Round-Robin Load Balancing

### Access the application
Open in your browser:

```
http://localhost
```

### Testing tips
- Open multiple browsers (Chrome, Firefox, Edge)
- Use incognito/private windows
- Refresh repeatedly

Each request will be served by a **different Q2A replica**.

---

## Viewing Logs

To observe round-robin behavior and container activity:

```bash
docker compose -f Zones-3.yaml logs -f q2a
```

You will see requests handled by different containers.

---

## Database Access Behavior

- All Q2A replicas connect to **the same MySQL database**
- Multiple users can:
  - Access the app simultaneously
  - Log in from different browsers
  - Create content concurrently
- This simulates a real multi-user production environment

---

## Why This Architecture Matters

This setup demonstrates:
- Horizontal scalability
- Network segmentation (security)
- Stateless application design
- Realistic production patterns using Docker Compose

It is ideal for:
- Learning Docker networking
- Load-balancer testing
- Portfolio projects
- Interviews and demos

---

## Stop and Clean Up

```bash
docker compose -f Zones-3.yaml down -v
```

---


## Author Notes

This project was built for **learning, demonstration, and sharing**.
Feel free to fork, improve, and adapt it.


---

## Looking Ahead

This project is designed to evolve into:
- Kubernetes (Ingress, Deployments, StatefulSets)
- Terraform-managed cloud infrastructure

---

Happy Dockering 🚀
