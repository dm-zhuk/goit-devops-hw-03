# Lesson-7: Kubernetes with Terraform, Docker, and Helm

This project creates an EKS cluster in the existing VPC (from lesson-5), pushes a Django Docker image to ECR, and deploys the application via Helm chart.

## Project Structure

- `main.tf`, `backend.tf`, `outputs.tf` — root Terraform configuration
- `modules/` — VPC, ECR, S3-backend (reused from lesson-5), new EKS module
- `charts/django-app/` — Helm chart for Django deployment (Deployment, Service, HPA, ConfigMap)

## Prerequisites

- AWS CLI configured (`aws configure`)
- kubectl installed
- Helm installed
- Docker installed (for pushing image)

## Usage

1. Initialize and apply Terraform (creates VPC, ECR, EKS cluster + nodes, S3/DynamoDB backend):
   ```bash
   terraform init
   terraform plan
   terraform apply   # Takes ~15–25 min for EKS provisioning

2. Access EKS:
   ```bash
   aws eks update-kubeconfig --name lesson-7-eks-cluster --region eu-west-1
   kubectl get nodes

3. Push Docker image to ECR (replace with your image):
   ```bash
   # Get your ECR URL from output
   terraform output ecr_repository_url

   # Authenticate Docker to ECR
   aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin <ECR_URL>

   # Tag & push
   docker tag my-django-app:latest <ECR_URL>:latest
   docker push <ECR_URL>:latest

4. Deploy Helm chart:
   ```bash
   cd charts/django-app
   helm lint .                  # Optional: validate chart
   helm install django-release . --namespace default --create-namespace

   # Watch pods become Ready
   kubectl get pods -w

   # Get external IP
   kubectl get svc django-release-service -o wide

   Open in browser: http://<EXTERNAL-IP> — your Django app should appear.

5. Cleanup:
   ```bash
   helm uninstall django-release
   terraform destroy
   # Important! Manually release Elastic IP in console