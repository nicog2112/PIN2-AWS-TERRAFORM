# AWS Infrastructure as Code with Terraform

## Table of Contents
- [Introduction](#introduction)
- [Setup Guide](#setup-guide)
  - [Bootstrap State Backend](#1-bootstrap-state-backend)
  - [Verify Resources](#2-verify-resources)
  - [Configuration Variables](#configuration-variables)
- [Project Structure](#project-structure)

## Introduction

This project automates the deployment of a web server infrastructure on AWS using Terraform. It includes a bootstrap process for managing Terraform state and the main infrastructure deployment for a basic Apache web server.

Key features:
- Automated infrastructure deployment
- State management with S3 and DynamoDB
- GitHub Actions integration
- Basic Apache web server

## Setup Guide

### 1. Bootstrap State Backend

```bash
cd bootstrap
terraform init
terraform plan
terraform apply
```

This creates:
- S3 bucket for state storage
- DynamoDB table for state locking

### 2. Infrastructure Deployment

The infrastructure is automatically deployed through GitHub Actions. On every push to the main branch that includes changes to the `infrastructure/` directory, the workflow will:
1. Initialize Terraform
2. Validate the configuration
3. Apply the changes

For manual deployment:
```bash
cd infrastructure
terraform init
terraform plan
terraform apply
```

### 3. Verify Resources

#### Bootstrap Verification

```bash
# Verify S3 bucket
aws s3 ls | grep nicolas-gauna.mundose22

# Verify DynamoDB table
aws dynamodb list-tables | grep terraformstatelock
```

#### Infrastructure Verification

```bash
# Verify VPC
aws ec2 describe-vpcs --filters "Name=tag:Name,Values=terraform-vpc"

# Verify EC2 instance
aws ec2 describe-instances --filters "Name=tag:Name,Values=webserver" "Name=instance-state-name,Values=running"

# Test web server
curl http://$(terraform output -raw Webserver-Public-IP)
```

### Configuration Variables

#### Bootstrap (`bootstrap/variables.tf`)

- `name_of_s3_bucket`: S3 bucket name for state storage
- `dynamo_db_table_name`: DynamoDB table name for state locking

#### Infrastructure (`infrastructure/variables.tf`)

- `aws_region`: AWS region for deployment
- `vpc_cidr`: CIDR block for VPC
- `subnet_cidr`: CIDR block for subnet
- `instance_type`: EC2 instance type
- `ami_id`: AMI ID for web server

## Project Structure

### Infrastructure Components
- `bootstrap/`
  - `main.tf`: Creates S3 bucket and DynamoDB table for state management
  - `variables.tf`: Bootstrap configuration variables

- `infrastructure/`
  - `backend.tf`: Configures Terraform backend
  - `main.tf`: EC2 instance configuration
  - `setup.tf`: VPC and networking setup
  - `setup_apache.sh`: Apache installation script
  - `variables.tf`: Infrastructure variables

### CI/CD
- `.github/workflows/`
  - `TerraformApply.yml`: Automated deployment workflow
  - `TerraformDestroy.yml`: Infrastructure teardown workflow
