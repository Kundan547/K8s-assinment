# K8s-assinment
# Kubernetes Microservices Deployment

This repository contains a complete Kubernetes setup for a **frontend**, **backend**, and **PostgreSQL database** with proper namespaces, Horizontal Pod Autoscaling (HPA), and supporting scripts for deployment, scaling, rollback, and cleanup.

---

## 🏗 Architecture

```text
          +-----------------------+
          |    Frontend Pods      |  (Namespace: frontend)
          |  (kundan547/sportdev) |
          +----------+------------+
                     |
                     v
          +----------+------------+
          |    Backend Pods       |  (Namespace: backend)
          |   (Node.js / API)     |
          +----------+------------+
                     |
                     v
          +----------+------------+
          | PostgreSQL StatefulSet|  (Namespace: database)
          |   Persistent Storage  |
          +-----------------------+

      [HPA monitors Frontend & Backend Pods]
🚀 Deployment Steps
1️⃣ Create Namespaces

kubectl apply -f namespace/
2️⃣ Deploy Database

kubectl apply -f database/
3️⃣ Deploy Backend

kubectl apply -f backend/
4️⃣ Deploy Frontend

kubectl apply -f frontend/
5️⃣ Apply Horizontal Pod Autoscaling

kubectl apply -f hpa/
⚙️ Scripts Usage
Deploy all components

./scripts/deploy.sh
Scale deployment manually


./scripts/scale.sh <deployment-name> <replica-count>
Rollback to previous deployment


./scripts/rollback.sh <deployment-name>
Test HPA scaling


./scripts/test-hpa.sh
Cleanup all resources

./scripts/cleanup.sh
📡 Services Access
Frontend Service: Exposed internally via ClusterIP (change to LoadBalancer/Ingress if external access is needed).

Backend Service: Internal ClusterIP accessible by frontend.

Database Service: Internal ClusterIP accessible by backend.

🔍 Notes
Secrets are stored in backend-secret.yaml — update credentials before deploying.

Persistent storage is configured via database-pvc.yaml.

Adjust resource limits and HPA thresholds based on workload.

All deployments are namespace-scoped for better isolation.

🛠 Tech Stack
Kubernetes (Deployments, Services, StatefulSets, HPA, PVC)

PostgreSQL (Database StatefulSet)

Custom Docker Images for Frontend & Backend

Namespace Isolation for microservices

Bash Scripts for automation

📬 Contact
Maintainer: Kundan Vyas
Email: kundanvyas197@gmail.com


