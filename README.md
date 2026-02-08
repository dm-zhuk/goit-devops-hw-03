# Django App CI/CD: Multi-Engine Database Module
This branch (lesson-db-module) implements a production-grade Terraform orchestration to deploy a containerized Django application with a flexible AWS database backend.

## Project Architecture
The project is structured into independent, reusable modules. The root **main.tf** orchestrates the flow of data between networking, compute, and storage layers.

## Key Components
- VPC Module: Creates a secure network across 3 AZs.
- EKS Module: Provisions the Kubernetes cluster for our application.
- RDS Module (Refactored): A unified module that switches between Aurora Cluster and Standard RDS based on the use_aurora variable.

- GitOps (Argo CD): Uses the App-of-Apps pattern to bootstrap the Django application and its PostgreSQL dependencies.

## Module Logic:
The RDS/Aurora Toggle
The RDS module is built for Environment Portability. It uses conditional logic to switch between a cost-efficient single instance for development and a high-availability cluster for production.

Conditional Resource Deployment:

- Standard RDS: Activated when use_aurora = false. Provisions a single aws_db_instance with multi_az support.

- Aurora Cluster: Activated when use_aurora = true. Provisions an aws_rds_cluster with a configurable replica_count.

    ## Aurora Cluster (Production)
            use_aurora            = true
            instance_class        = "db.t3.medium"
            aurora_instance_count = 2

## Configuration & Deployment

**Variable**                **Type**	**Description**
use_aurora	                bool	    Toggle between Aurora Cluster and Standard RDS.
multi_az	                bool	    Enables Deployment across multiple Availability Zones.
backup_retention_period	    number	    Retention window (in days) for automated backups.
tags	                    map	        Universal tagging applied to SG, Subnet Groups, and Instances.
instance_class	            string	    Hardware tier (e.g., db.t3.micro).

2. Deployment Sequence
Inside multipass shell **minikube-vm**, run:
    # Initialize S3 backend and providers
        terraform init

    # Validate configuration syntax
        terraform validate

    # Review the execution plan
        terraform plan -out=db.plan

    # Deploy to AWS
        terraform apply "db.plan"

![Validation Status](img/validation.png)

## Deployment Example
To deploy a production-ready Aurora cluster with 2 replicas and a 7-day backup window, configure terraform.tfvars as follows:

        project_name            = "goit-devops-hw03"
        use_aurora              = true
        replica_count           = 2
        instance_class          = "db.t3.medium"
        backup_retention_period = 7
        multi_az                = true
        tags = {
        Environment             = "Production"
        Owner                   = "DevOps-Team"
        }

## Security and PersistenceState Management:
Configured in **backend.tf** using S3 for storage and DynamoDB for state locking.

### Security Group "Handshake" Logic
The project implements a Least Privilege networking model. The database is strictly isolated in private subnets and only accepts traffic via a dynamic reference to the EKS worker nodes.

    # modules/rds/shared.tf
        ingress {
        from_port       = var.db_port
        to_port         = var.db_port
        protocol        = "tcp"
        security_groups = [var.eks_node_sg_id] # Handshake: Only allow EKS Nodes
        }

## Credential Masking:
All database credentials in **outputs.tf** are marked as sensitive = true to prevent accidental exposure in logs.
 
## Network Isolation:
The database is strictly located in private_subnets, accessible only by the EKS Worker Node Security Group.
 
## Verification
 After a successful apply, retrieve Django connection string directly from the Terraform outputs:
 
 Get the raw connection string for .env file
        terraform output -raw django_database_url

## Project Outcome Summary

Infrastructure: Successfully provisioned a VPC (3 AZs), EKS Cluster (v1.34), and RDS Instance via Terraform.

    module.rds.aws_db_instance.this[0]: Creating...
    module.rds.aws_db_instance.this[0]: Still creating... [10s elapsed]
    ...
    module.rds.aws_db_instance.this[0]: Creation complete after 6m8s [id=db-IWPN7ERBT3AJ2PVW2LGNDBFJVQ]

Database Layer: Deployed PostgreSQL 17.2 on RDS db.t3.micro using a custom Parameter Group. Verified successful creation in 6m 8s.

CI/CD Layer: Successfully bootstrapped Argo CD via Helm.

Storage Resolution: Identified a pending state in the Jenkins StatefulSet caused by missing EBS driver configurations. Successfully implemented a manual gp3 StorageClass and resolved driver conflicts via the AWS CLI.

Cost Management: Terminated all resources immediately following verification to ensure budget compliance.

### Kubernetes Cluster Readiness
Worker nodes and Argo CD pods in a healthy state.
![Cluster Status](img/nodes.png)