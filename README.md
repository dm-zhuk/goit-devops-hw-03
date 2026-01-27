# Lesson-7: Kubernetes with Terraform, Docker, and Helm

This project creates an EKS cluster in existing VPC, pushes Django Docker image to ECR, and deploys via Helm.

## Project Structure

- `main.tf`, `backend.tf`, `outputs.tf` — root Terraform config
- `modules/` — VPC, ECR, S3-backend (from lesson-5), new EKS
- `charts/django-app/` — Helm chart for Django deployment

## Usage

1. Initialize and apply Terraform:
   ```bash
   terraform init
   terraform plan
   terraform apply

2. Access EKS:
   ```bash
   aws eks update-kubeconfig --name lesson-7-eks-cluster --region eu-west-1
   kubectl get nodes

3. Push Docker image to ECR (replace with your image):
   ```bash
   aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin <ECR_URL>
   docker tag my-django-app:latest <ECR_URL>:latest
   docker push <ECR_URL>:latest

4. Deploy Helm chart:
   ```bash
   cd charts/django-app
   helm install django-release .
   kubectl get svc django-release-service -o wide  # Get external IP

5. Cleanup:
   ```bash
   helm uninstall django-release
   terraform destroy
   # Important! Manually release Elastic IP in console