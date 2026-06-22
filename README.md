# HR Ops Platform

<p align="center">
  <img src="https://img.shields.io/badge/AWS-EKS-orange?logo=amazonaws&logoColor=white" />
  <img src="https://img.shields.io/badge/Kubernetes-326CE5?logo=kubernetes&logoColor=white" />
  <img src="https://img.shields.io/badge/Terraform-844FBA?logo=terraform&logoColor=white" />
  <img src="https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=white" />
  <img src="https://img.shields.io/badge/Helm-0F1689?logo=helm&logoColor=white" />
  <img src="https://img.shields.io/badge/Jenkins-D24939?logo=jenkins&logoColor=white" />
  <img src="https://img.shields.io/badge/Node.js-339933?logo=nodedotjs&logoColor=white" />
  <img src="https://img.shields.io/badge/PostgreSQL-4169E1?logo=postgresql&logoColor=white" />
</p>

> DevOps-focused portfolio project for deploying a containerized HR backend application to AWS EKS using Terraform, Kubernetes, Helm, Jenkins, Docker, Amazon ECR, Amazon RDS, S3 and AWS-managed infrastructure services.

---

## Project Status

This is a **portfolio / learning project** created to practice production-like cloud infrastructure patterns.

The goal of the project is not to represent a real production HR system, but to demonstrate how modern infrastructure components can work together in a realistic cloud-native environment.

The project focuses on:

* Infrastructure as Code
* Kubernetes-based application deployment
* Containerized backend services
* CI/CD workflows
* AWS-managed services
* IAM-based authentication
* Secrets and storage integration
* Production-like DevOps thinking

---

## About The Project

HR Ops Platform is a DevOps-oriented infrastructure project built around a small HR backend service.

The project demonstrates how a backend application can be containerized, deployed to Kubernetes, connected to managed cloud services, and delivered through a CI/CD pipeline.

The main goal was to understand how the following components work together:

* AWS cloud infrastructure
* Terraform-managed resources
* Amazon EKS Kubernetes cluster
* Docker container images
* Amazon ECR private registry
* Helm-based deployments
* Jenkins CI/CD pipeline
* AWS RDS PostgreSQL database
* AWS Secrets Manager
* IAM roles and AWS Pod Identity
* S3-based file/report storage

---

## High-Level Architecture

```text
User
  ↓
AWS Load Balancer
  ↓
Kubernetes Ingress
  ↓
Backend Service
  ↓
Backend Pods running on EKS
  ↓
 ├── PostgreSQL database on Amazon RDS
 ├── Secrets from AWS Secrets Manager
 └── Report/file storage in Amazon S3


Developer Push
  ↓
GitHub Repository
  ↓
Jenkins Pipeline running in Kubernetes
  ↓
Kaniko container image build
  ↓
Amazon ECR
  ↓
Helm deployment
  ↓
Amazon EKS
```

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
* AWS Pod Identity

### DevOps & Platform

* Terraform
* Kubernetes
* Helm
* Jenkins
* Kaniko
* Docker
* Dockerfile

### Backend

* Node.js
* Express.js
* PostgreSQL

---

## Main Features

### Infrastructure

* Multi-AZ Amazon EKS cluster
* Terraform-managed infrastructure
* Private container registry with Amazon ECR
* Managed PostgreSQL database with Amazon RDS
* Kubernetes ingress through AWS Load Balancer Controller
* IAM-based pod authentication
* Dynamic EBS volume provisioning for Jenkins
* S3 integration for report/file storage

### CI/CD

* Jenkins running inside Kubernetes
* Dynamic Jenkins agent pods
* Kaniko-based Docker image builds
* Automated image push to Amazon ECR
* Helm-based deployment to Kubernetes
* Kubernetes rollout verification

### Backend

* HR-related backend API
* Employee CRUD endpoints
* PostgreSQL database integration
* AWS Secrets Manager integration
* S3 upload endpoint for generated reports/files

---

## Project Structure

```text
hr-ops-platform/
│
├── backend/
│   └── Node.js / Express backend application
│
├── helm/
│   └── Helm chart for Kubernetes deployment
│
├── infrastructure/
│   └── terraform/
│       └── Terraform infrastructure configuration
│
├── jenkins/
│   └── Jenkins pipeline and Kubernetes-related CI/CD setup
│
├── kubernetes/
│   └── Kubernetes manifests and configuration files
│
└── README.md
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
Push Image to Amazon ECR
      ↓
Helm Upgrade
      ↓
Kubernetes Rollout
```

The CI/CD pipeline is designed to simulate a production-like deployment workflow where the application image is built inside Kubernetes, pushed to a private registry, and deployed through Helm.

---

## Infrastructure Highlights

### Terraform

The infrastructure is managed with Terraform and separated into logical infrastructure components, such as:

* networking
* EKS
* ECR
* RDS
* IAM
* storage

This structure helped me understand how cloud infrastructure can be created, modified and destroyed in a repeatable way.

### Kubernetes

The project uses Kubernetes resources such as:

* Deployments
* Services
* Ingress
* Namespaces
* PersistentVolumeClaims
* ServiceAccounts

The goal was to understand how applications run inside a Kubernetes cluster and how services, pods, ingress rules and cloud integrations work together.

### AWS Pod Identity

Instead of storing long-term AWS credentials inside the application or Kubernetes manifests, workloads use IAM-based authentication through AWS Pod Identity.

This was used for:

* Jenkins deployment permissions
* Backend access to AWS Secrets Manager
* Backend access to Amazon S3
* EBS CSI Driver permissions

---

## Storage

### Persistent Jenkins Storage

Jenkins uses dynamically provisioned EBS volumes through the AWS EBS CSI Driver.

This allows Jenkins data to persist even if the Jenkins pod is restarted or rescheduled.

### S3 Report Storage

The backend includes an endpoint for uploading generated reports/files to an S3 bucket.

Example endpoint:

```bash
POST /reports
```

---

## Prerequisites

To work with this project from the terminal, the following tools are required:

* AWS account
* AWS CLI configured with appropriate permissions
* Terraform
* kubectl
* Helm
* Docker
* Git
* Node.js and npm
* Access to an AWS region where EKS, RDS, ECR and related services can be created

No IDE is required to run the infrastructure commands. The project can be managed from the command line.

---

## Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/TothLaszlo7/hr-ops-platform.git
cd hr-ops-platform
```

### 2. Configure AWS credentials

Make sure your AWS CLI is configured:

```bash
aws configure
```

Check the active identity:

```bash
aws sts get-caller-identity
```

### 3. Provision infrastructure with Terraform

Navigate to the Terraform configuration:

```bash
cd infrastructure/terraform
```

Initialize Terraform:

```bash
terraform init
```

Check the planned infrastructure changes:

```bash
terraform plan
```

Apply the infrastructure:

```bash
terraform apply
```

### 4. Configure kubectl access to EKS

After the EKS cluster is created, update your local kubeconfig:

```bash
aws eks update-kubeconfig --region <aws-region> --name <cluster-name>
```

Verify cluster access:

```bash
kubectl get nodes
```

### 5. Deploy the backend with Helm

From the repository root:

```bash
helm upgrade --install hr-ops ./helm/hr-ops
```

Check the rollout status:

```bash
kubectl get pods
kubectl get services
kubectl get ingress
```

---

## Useful Commands

Check Kubernetes resources:

```bash
kubectl get all
```

Check pods:

```bash
kubectl get pods
```

Check logs:

```bash
kubectl logs <pod-name>
```

Check rollout status:

```bash
kubectl rollout status deployment/<deployment-name>
```

Check Helm releases:

```bash
helm list
```

---

## Security Notes

This project was built with security awareness in mind.

Important security-related practices:

* No hardcoded AWS access keys should be committed to the repository.
* AWS access is handled through IAM roles and AWS Pod Identity where possible.
* Application secrets should be stored in AWS Secrets Manager.
* Infrastructure permissions should follow the principle of least privilege.
* Local `.env` files and sensitive configuration files should not be committed.

Before publishing or sharing the project, always check that no secrets, tokens, passwords or private keys are included in the repository history.

---

## AWS Cost Warning

This project can create real AWS resources that may generate costs, including:

* EKS cluster
* EC2 worker nodes
* RDS database
* Load Balancer
* EBS volumes
* S3 storage
* NAT Gateway or networking-related resources, depending on the Terraform setup

After testing, destroy unused infrastructure to avoid unexpected costs.

Example cleanup command:

```bash
terraform destroy
```

---

## Quality & Validation

This project includes infrastructure and deployment validation through:

* Terraform validation and planning
* Kubernetes rollout checks
* Helm-based deployment process
* Manual endpoint testing
* Jenkins pipeline execution
* Infrastructure troubleshooting and log inspection

Example validation commands:

```bash
terraform validate
terraform plan
kubectl get pods
kubectl get ingress
helm list
```

Future improvements include adding a dedicated automated backend test suite.

---

## Lessons Learned

This project helped me gain hands-on experience with production-like infrastructure concepts.

Key learning areas:

* Kubernetes debugging
* AWS IAM permission troubleshooting
* Helm deployment issues
* Jenkins running inside Kubernetes
* Dynamic Jenkins agent pods
* Kaniko-based container image builds
* AWS authentication flows
* EKS access management
* EBS-based persistent storage
* S3 integration
* Secrets Manager integration
* Terraform-based infrastructure modularization
* Understanding how application deployment and cloud infrastructure work together

The most valuable part of the project was seeing how many different infrastructure layers need to work correctly together for a cloud-native application to run reliably.

---

## Future Improvements

Planned or possible improvements:

* Add architecture diagram
* Add Jenkins pipeline screenshots
* Add Kubernetes resource screenshots
* Add Prometheus and Grafana monitoring
* Add Loki log aggregation
* Add HTTPS/TLS automation
* Add Horizontal Pod Autoscaling
* Add multi-environment deployment support
* Add automated backend API tests
* Add GitOps workflow with ArgoCD
* Add frontend application

---

## Author

**Laszlo Toth**

GitHub: https://github.com/TothLaszlo7

LinkedIn: https://www.linkedin.com/in/laszlo-toth-it

