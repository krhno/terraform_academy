provider "aws" {
  region = var.region
}

# VPC Module
module "vpc_module" {
  source  = "app.terraform.io/oruiz/vpc_module/aws"
  version = "1.0.1"

  region                      = var.region
  project_name                = var.project_name
  environment                 = var.environment
  vpc_cidr                    = var.vpc_cidr
  public_subnet_cidr          = var.public_subnet_cidr
  private_app_subnet_cidr     = var.private_app_subnet_cidr
}

# ECS Module
module "ecs_module" {
  source  = "app.terraform.io/oruiz/ecs_module/aws"
  version = "1.0.2"

  allowed_ip   = var.allowed_ip
  key_name     = var.key_name
  docker_image = var.docker_image
  vpc_id       = module.vpc_module.vpc_id
  private_app_subnet_id = module.vpc_module.private_app_subnet_id
  public_subnet_id      = module.vpc_module.public_subnet_id

  depends_on = [module.vpc_module]
}
