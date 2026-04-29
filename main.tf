terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# VPC Module
module "vpc_module" {
  source = "./vpc_module"

  region                      = var.region
  project_name                = var.project_name
  environment                 = var.environment
  vpc_cidr                    = var.vpc_cidr
  public_subnet_cidr          = var.public_subnet_cidr
  private_app_subnet_cidr     = var.private_app_subnet_cidr
}

# ECS Module
module "ecs_module" {
  source = "./ecs_module"

  allowed_ip   = var.allowed_ip
  key_name     = var.key_name
  docker_image = var.docker_image

  depends_on = [module.vpc_module]
}
