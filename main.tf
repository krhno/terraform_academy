provider "aws" {
  region = var.region
}

# VPC Module
module "vpc_module" {
  source  = "app.terraform.io/oruiz/vpc_module/aws"
  version = "1.1.0"

  region                      = var.region
  project_name                = var.project_name
  environment                 = var.environment
  vpc_cidr                    = var.vpc_cidr
  public_subnet_cidr_az1      = var.public_subnet_cidr_az1
  public_subnet_cidr_az2      = var.public_subnet_cidr_az2
  private_app_subnet_cidr     = var.private_app_subnet_cidr
}

# ECS Module
module "ecs_module" {
  source  = "app.terraform.io/oruiz/ecs_module/aws"
  version = "1.1.1"

  allowed_ip   = var.allowed_ip
  docker_image = var.docker_image
  vpc_id       = module.vpc_module.vpc_id
  private_app_subnet_id = module.vpc_module.private_app_subnet_id
  public_subnet_id_az1  = module.vpc_module.public_subnet_id_az1
  public_subnet_id_az2  = module.vpc_module.public_subnet_id_az2

  depends_on = [module.vpc_module]
}
