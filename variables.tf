# Provider Variables
variable "region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

# Project Variables
variable "project_name" {
  type        = string
  description = "Project name"
  default     = "oruiz"
}

variable "environment" {
  type        = string
  description = "Environment name"
  default     = "testing"
}

# VPC Variables
variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block"
  default     = "192.168.0.0/16"
}

variable "public_subnet_cidr" {
  type        = string
  description = "Public subnet CIDR block"
  default     = "192.168.0.0/24"
}

variable "private_app_subnet_cidr" {
  type        = string
  description = "Private app subnet CIDR block"
  default     = "192.168.1.0/24"
}

# ECS Variables
variable "allowed_ip" {
  type        = string
  description = "IP address allowed to access the security group"
  default     = "177.249.60.131/32"
}

variable "key_name" {
  type        = string
  description = "EC2 key pair name for ECS instances"
}

variable "docker_image" {
  type        = string
  description = "Docker image URI to deploy in the ECS cluster"
  default     = "nginx:latest"
}
