# VPC Module Outputs
output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc_module.vpc_id
}

output "alb_dns_name" {
  description = "Application Load Balancer DNS Name - use this to access your ECS service"
  value       = module.ecs_module.alb_dns_name
}