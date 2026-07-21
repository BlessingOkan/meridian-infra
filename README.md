# Meridian Labs — Cloud Infrastructure Portfolio

## Video: https://somup.com/cOirV1Vnw8c

## Project Summary

This project provisions cloud infrastructure for a fictional company, Meridian Labs, using OpenTofu (an open-source Terraform fork) and LocalStack. It was built as part of CST 365 DevOps and CI/CD at Concordia University St. Paul and demonstrates end-to-end Infrastructure as Code with a fully automated GitOps pipeline powered by GitHub Actions.

## Problem Statement

Cloud infrastructure that is provisioned manually is slow, error-prone, and impossible to audit. Teams that manage servers by hand cannot reproduce environments reliably, cannot track who changed what, and cannot roll back safely when something breaks. This project solves that by treating infrastructure the same way software teams treat code: every resource is defined in version-controlled configuration files, every change flows through a pull request, and deployments are automated rather than manual.

## Technologies Used

- **OpenTofu** — Infrastructure as Code (open-source Terraform fork)
- **LocalStack** — Local AWS simulation running in Docker
- **GitHub Actions** — CI/CD and GitOps automation
- **HCL (HashiCorp Configuration Language)** — Infrastructure configuration syntax
- **AWS Provider (via LocalStack)** — VPC, Subnet, EC2, S3

## Architecture Overview

Developer pushes code → GitHub Pull Request → GitHub Actions runs tofu plan → Merge to main → GitHub Actions runs tofu apply → LocalStack (simulated AWS) provisions VPC, Subnet, EC2, and S3 bucket.

All infrastructure state is tracked in a local backend (terraform.tfstate), and the GitOps pipeline enforces that no infrastructure change can be applied without first being reviewed as code.

## Key Design Decisions

**1. OpenTofu over Terraform**
OpenTofu is the community-maintained open-source fork of Terraform following HashiCorp's license change. It is fully compatible with existing HCL configurations and is increasingly adopted by companies that want to avoid vendor lock-in.

**2. LocalStack for local testing**
Rather than provisioning real AWS resources during development and incurring costs, LocalStack simulates the AWS API locally. This enables fast iteration, offline development, and safe experimentation without touching production accounts.

**3. Variable validation**
The environment variable uses an OpenTofu validation block to enforce that only dev, staging, or production are accepted values. This prevents configuration drift and catches typos before any infrastructure is touched.

**4. GitOps pattern**
The GitHub Actions pipeline separates tofu plan (runs on pull requests) from tofu apply (runs only on merge to main). This ensures every infrastructure change is reviewed before it is deployed, mirroring how mature DevOps teams manage infrastructure at scale.

**5. s3_use_path_style**
LocalStack requires path-style S3 addressing rather than the default virtual-hosted style. This was discovered through hands-on debugging when the S3 bucket creation silently hung for over 11 minutes during apply. Adding s3_use_path_style = true to the provider block resolved the issue.

## Challenges and How I Solved Them

**Silent S3 failure during tofu apply**
After running tofu apply, the S3 bucket resource hung indefinitely with no error. The root cause was that LocalStack requires s3_use_path_style = true in the AWS provider block. One line of configuration fixed an 11-minute hang.

**Large file accidentally committed to Git**
The .terraform directory containing the AWS provider binary at roughly 648 MB was accidentally pushed to GitHub. The fix was to delete the .git directory, add a proper .gitignore, reinitialize the repository, and push a clean history.

**GitHub Actions apply failure on LocalStack**
The tofu apply step in GitHub Actions fails as expected because the Actions runner cannot reach a LocalStack instance running on localhost. This is by design. In a real production environment the apply step would target a real cloud provider. The plan step passes successfully, validating the configuration is correct.

## Outcomes

- Fully functional IaC configuration provisioning VPC, subnet, EC2 instance, and S3 bucket against LocalStack
- GitOps pipeline that automatically runs tofu plan on every pull request and tofu apply on every merge to main
- Variable validation enforcing environment naming conventions
- Clean repository structure with proper .gitignore and modular file layout

## How to Run Locally

Start LocalStack: localstack start
Initialize OpenTofu: tofu init
Preview changes: tofu plan
Deploy: tofu apply

## Repository Structure

meridian-infra/
├── main.tf           # Provider config and resource definitions
├── variables.tf      # Input variables with validation
├── outputs.tf        # Output values after apply
├── .gitignore        # Excludes .terraform/ and state files
└── .github/workflows/infra.yml   # GitHub Actions GitOps pipeline

## Author

Blessing Okan — Concordia University St. Paul
BS Information Systems | CST 365 DevOps and CI/CD
