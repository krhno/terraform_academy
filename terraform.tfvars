# Copy this file to terraform.tfvars and fill in your values

# AWS Region
region = "us-east-1"

# Project Configuration
project_name = "oruiz"
environment  = "testing"

# VPC Configuration
vpc_cidr                  = "192.168.0.0/16"
public_subnet_cidr        = "192.168.0.0/24"
private_app_subnet_cidr   = "192.168.1.0/24"

# ECS Configuration
allowed_ip = "177.249.60.131/32"  # Change to your IP address

# EC2 Key Pair - REQUIRED
key_name = "oruiz-key"   # Change to your EC2 key pair name

# Docker Image - Can be ECR or any public Docker registry
docker_image = "005747243382.dkr.ecr.us-east-1.amazonaws.com/terraform-academy/oruiz:latest"