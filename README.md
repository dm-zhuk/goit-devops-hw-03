# Lesson 8-9: CI/CD with Jenkins, Kaniko, ECR & Argo CD GitOps

## Overview

Full GitOps pipeline:
- Jenkins builds Docker image with Kaniko
- Pushes to AWS ECR
- Updates image tag in `values.yaml`
- Commits & pushes to branch `lesson-8-9`
- Argo CD watches branch `lesson-8-9` → auto-syncs new image

## How to apply Terraform

```bash
terraform init
terraform plan
terraform apply