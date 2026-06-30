# Meridian Labs — Cloud Infrastructure

## Overview
This project provisions cloud infrastructure for Meridian Labs using OpenTofu and LocalStack. Built as part of CST 365 DevOps and CI/CD at Concordia University St. Paul.

## What This Deploys
- VPC with DNS support enabled
- Public subnet
- EC2 t2.micro instance
- S3 bucket with environment tagging

## Tech Stack
- OpenTofu (Infrastructure as Code)
- LocalStack (local AWS simulation)
- GitHub Actions (GitOps CI/CD pipeline)
- HCL (HashiCorp Configuration Language)

## How to Run Locally
1. Start LocalStack: `localstack start`
2. Initialize OpenTofu: `tofu init`
3. Preview infrastructure: `tofu plan`
4. Deploy infrastructure: `tofu apply`

## GitOps Pipeline
The GitHub Actions pipeline in `.github/workflows/infra.yml` runs automatically on every push. Tofu plan runs on pull requests. Tofu apply runs on push to main.

## Variables
- `region` — AWS region (default: us-east-1)
- `environment` — Must be `dev`, `staging`, or `production` (default: dev)

## Author
Blessing Okan —
