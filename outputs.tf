# VPC Module Outputs
output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc_module.vpc_id
}

output "public_subnet_id" {
  description = "Public Subnet ID"
  value       = module.vpc_module.public_subnet_id
}

output "private_app_subnet_id" {
  description = "Private App Subnet ID"
  value       = module.vpc_module.private_app_subnet_id
}

# ECS Module Outputs
output "ecs_cluster_id" {
  description = "ECS Cluster ID"
  value       = module.ecs_module.ecs_cluster_id
}

output "ecs_service_name" {
  description = "ECS Service Name"
  value       = module.ecs_module.ecs_service_name
}

output "alb_dns_name" {
  description = "Application Load Balancer DNS Name - use this to access your ECS service"
  value       = module.ecs_module.alb_dns_name
}

output "alb_zone_id" {
  description = "Application Load Balancer Zone ID"
  value       = module.ecs_module.alb_zone_id
}

output "security_group_id" {
  description = "Security Group ID for ECS cluster"
  value       = module.ecs_module.security_group_id
}
