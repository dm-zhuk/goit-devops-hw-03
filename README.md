# Django App CI/CD: Terraform, Jenkins & Argo CD

This project demonstrates a complete GitOps lifecycle for a Django web application using Infrastructure as Code (Terraform), a CI/CD pipeline (Jenkins + Kaniko), and automated deployment (Argo CD) on AWS EKS.

---

## 1. How to Apply Terraform
The infrastructure is managed as code and deployed in the `eu-west-1` region.

* **Step 1: Initialize Terraform**
  ```bash
  terraform init

* **Step 2: Create Resources Deploy the VPC, EKS Cluster, and ECR Registry**

```bash
terraform apply --auto-approve
Result: A managed Kubernetes cluster and a private ECR registry are created at 829703038395.dkr.ecr.eu-west-1.amazonaws.com/lesson-8-9-ecr.

## 2. How to Verify Jenkins Job
Jenkins automates the building of the Docker image and the updating of the deployment version in Git.

Build & Push: The pipeline uses a Kaniko agent to build the Docker image and push it to AWS ECR. Authentication is handled via a Kubernetes Secret regcred containing a valid AWS token.

Update Git: Upon a successful push, Jenkins automatically edits lesson-8-9/charts/django-app/values.yaml to update the tag (e.g., to version 45).

Verification:

Jenkins UI: The pipeline job should show a "Success" status (green).

GitHub: A new automated commit titled update tag 45 [ci skip] should appear in the dm-zhuk/goit-devops-hw-03 repository.

## 3. How to See Results in Argo CD
Argo CD implements GitOps by synchronizing the cluster state with the Git configuration.

Accessing the UI:

* **Retrieve the LoadBalancer URL:**

```bash

kubectl get svc -n argocd argo-cd-argocd-server

* **URL: https://a04ef8ea87ecf4604a31e5fc90291149-530623759.eu-west-1.elb.amazonaws.com**

Verification in Dashboard:

Log in and locate the django-app application.

You will see a Synced status with a green checkmark.

Clicking the application card will display the resource tree (Deployment, Service, Pods).

Confirming Deployment: Verify that the running pods are using the latest image tag pushed by Jenkins:

```bash
kubectl describe pod -n default | grep Image:
Result: The image tag should match the Jenkins build number (e.g., :45).

## 4. Resource Cleanup

```bash
terraform destroy --auto-approve