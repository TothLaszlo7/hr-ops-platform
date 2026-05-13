# HR Ops Platform

> Cloud-native HR backend platform running on AWS EKS with Terraform-managed infrastructure, Kubernetes deployments, Jenkins CI/CD, Helm, RDS, S3 and AWS-managed services.

---

## About The Project

HR Ops Platform is a DevOps-focused portfolio project built to demonstrate modern cloud infrastructure and deployment workflows on AWS.

The platform includes:

- Infrastructure as Code with Terraform
- Kubernetes workloads running on Amazon EKS
- Jenkins-based CI/CD pipelines
- Docker image builds with Kaniko
- Helm-based deployments
- AWS RDS PostgreSQL integration
- AWS Secrets Manager integration
- AWS Pod Identity / IAM role integration
- Persistent Jenkins storage using EBS CSI Driver
- S3 report storage integration

The main goal of the project was not only deploying applications, but understanding how modern cloud-native infrastructure components work together in a real-world environment.

---

## Architecture

### High Level Architecture

```text
User
  ↓
AWS Load Balancer
  ↓
Kubernetes Ingress
  ↓
Backend Service
  ↓
Backend Pods (EKS)
  ↓
 ├── PostgreSQL (RDS)
 ├── Secrets Manager
 └── S3 Bucket

Jenkins CI/CD
  ↓
Kaniko Image Build
  ↓
Amazon ECR
  ↓
Helm Deployment
  ↓
Amazon EKS
````

---

## Built With

### Cloud & Infrastructure

* AWS EKS
* AWS ECR
* AWS RDS PostgreSQL
* AWS S3
* AWS IAM
* AWS Secrets Manager
* AWS Load Balancer Controller
* AWS EBS CSI Driver

### DevOps & Platform

* Terraform
* Kubernetes
* Helm
* Jenkins
* Kaniko
* Docker

### Backend

* Node.js
* Express.js
* PostgreSQL

---

## Features

### Infrastructure

* Multi-AZ EKS cluster
* Private container registry (ECR)
* Managed PostgreSQL database
* Dynamic EBS volume provisioning
* Kubernetes ingress with AWS Load Balancer
* IAM-based pod authentication

### CI/CD

* Jenkins running inside Kubernetes
* Dynamic Jenkins agent pods
* Kaniko-based container builds
* Automated image push to ECR
* Helm-based Kubernetes deployments
* Rollout verification

### Backend

* Employee CRUD endpoints
* PostgreSQL integration
* Secrets Manager integration
* S3 file upload endpoint

---

## Project Structure

```text
hr-ops-platform/
│
├── backend/
├── helm/
├── infrastructure/
│   └── terraform/
├── jenkins/
└── kubernetes/
```

---

## CI/CD Flow

```text
Developer Push
      ↓
GitHub Repository
      ↓
Jenkins Pipeline
      ↓
Kaniko Docker Build
      ↓
Push Image to ECR
      ↓
Helm Upgrade
      ↓
Kubernetes Rollout
```

---

## Infrastructure Highlights

### Terraform Modules

The infrastructure is separated into reusable Terraform modules:

* network
* eks
* ecr
* rds
* iam
* storage

### Kubernetes

The project uses:

* Deployments
* Services
* Ingress
* PersistentVolumeClaims
* Namespaces
* ServiceAccounts

### AWS Pod Identity

Instead of hardcoded AWS credentials, workloads authenticate using IAM roles attached to Kubernetes service accounts.

This was implemented for:

* Jenkins deployment pipeline
* Backend Secrets Manager access
* EBS CSI Driver
* S3 integration

---

## Storage

### Persistent Jenkins Storage

Jenkins uses dynamically provisioned EBS volumes through the AWS EBS CSI Driver.

### S3 Report Storage

The backend exposes a `/reports` endpoint which uploads generated files directly into an S3 bucket.

Example:

```bash
curl -X POST http://localhost:8080/reports
```

---

## Lessons Learned

This project provided hands-on experience with:

* Kubernetes debugging
* IAM permission troubleshooting
* Helm deployment issues
* Jenkins Kubernetes agents
* Kaniko container builds
* AWS authentication flows
* EKS access management
* Storage provisioning
* Infrastructure modularization

---

## Future Improvements

* ArgoCD / GitOps workflow
* Monitoring stack (Prometheus + Grafana)
* Horizontal Pod Autoscaling
* Loki log aggregation
* HTTPS/TLS automation
* Frontend application
* Multi-environment deployments

---

## Screenshots & Diagrams

### Architecture Diagram

*Add Excalidraw diagram here*

### Jenkins Pipeline

*Add Jenkins pipeline screenshot here*

### Kubernetes Resources

*Add kubectl / Lens screenshots here*

---

## Getting Started

### Clone Repository

```bash
git clone https://github.com/TothLaszlo7/hr-ops-platform.git
```

### Terraform Infrastructure

```bash
terraform init
terraform apply
```

### Deploy Backend

```bash
helm upgrade --install hr-ops ./helm/hr-ops
```

---

## Author

Laszlo Toth

GitHub:
[https://github.com/TothLaszlo7](https://github.com/TothLaszlo7)
