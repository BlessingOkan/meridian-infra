terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "local" {
    path = "terraform.tfstate"
  }
}

provider "aws" {
  region                      = var.region
  access_key                  = "test"
  secret_key                  = "test"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  # Required for LocalStack — without this, S3 requests hang indefinitely
  s3_use_path_style           = true


  endpoints {
    ec2 = "http://localhost:4566"
    s3  = "http://localhost:4566"
  }
}

# VPC provides network isolation for all Meridian Labs resources
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.environment}-vpc"
    Environment = var.environment
  }
}

resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.environment}-subnet"
    Environment = var.environment
  }
}

resource "aws_instance" "main" {
  ami           = "ami-00000000000000000"
  # t2.micro is sufficient for dev and staging environments
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.main.id

  tags = {
    Name        = "${var.environment}-instance"
    Environment = var.environment
  }
}

resource "aws_s3_bucket" "main" {
  bucket = "${var.environment}-meridian-bucket"

  tags = {
    Name        = "${var.environment}-meridian-bucket"
    Environment = var.environment
  }
}
