# Meridian Labs — Cloud Infrastructure Portfolio
# Video: https://somup.com/cOirV1Vnw8c
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
