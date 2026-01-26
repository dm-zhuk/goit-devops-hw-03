# Lesson-7 Terraform Project

This project sets up AWS infrastructure using Terraform: S3+DynamoDB for state, VPC with subnets, and ECR repo.

## Project Structure

- `main.tf`: Provider and module calls.
- `backend.tf`: Remote state config (S3 + DynamoDB).
- `outputs.tf`: Aggregated outputs.
- `modules/s3-backend/`: Creates S3 bucket (versioned, encrypted) and DynamoDB lock table.
- `modules/vpc/`: Creates VPC, 3 public/3 private subnets, IGW, NAT Gateway, and route tables.
- `modules/ecr/`: Creates ECR repo with scan-on-push and access policy.

## Usage Commands

1. Initialize: `terraform init`
2. Plan: `terraform plan`
3. Apply: `terraform apply`
4. Destroy: `terraform destroy`

Note: For backend, initially comment out backend.tf, apply to create resources, then uncomment and run `terraform init -migrate-state`.

## Module Explanations

- **s3-backend**: Stores Terraform state remotely with versioning and locking for team safety.
- **vpc**: Builds isolated network with public (internet-accessible) and private (outbound via NAT) subnets across 3 AZs for high availability.
- **ecr**: Registry for Docker images, with automatic vulnerability scanning.