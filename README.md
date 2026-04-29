# Terraform Academy - ECS Infrastructure

A complete Terraform configuration for deploying a containerized application on AWS ECS with networking, load balancing, and auto-scaling capabilities.

## 📋 Overview

This Terraform project creates a production-ready infrastructure for running Docker containers on AWS ECS. It uses modular architecture to organize resources into reusable components:

- **VPC Module**: Networking infrastructure (VPC, subnets, internet gateway)
- **ECS Module**: Container orchestration (ECS cluster, services, task definitions, ALB)

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────┐
│                        VPC                              │
│  (192.168.0.0/16)                                       │
│                                                         │
│  ┌──────────────────────────────────────────────────┐   │
│  │         Public Subnet (192.168.0.0/24)           │   │
│  │  ┌──────────────────────────────────────────┐    │   │
│  │  │  Application Load Balancer (ALB)         │    │   │
│  │  │  - Port 8000 (HTTP)                      │    │   │
│  │  └──────────────────────────────────────────┘    │   │
│  └──────────────────────────────────────────────────┘   │
│                          │                               │
│  ┌──────────────────────────────────────────────────┐   │
│  │      Private Subnet (192.168.1.0/24)            │   │
│  │  ┌──────────────────────────────────────────┐    │   │
│  │  │   ECS Cluster                            │    │   │
│  │  │  ┌────────────────────────────────────┐  │    │   │
│  │  │  │ EC2 Instance (t3.nano)             │  │    │   │
│  │  │  │ ┌──────────────────────────────┐   │  │    │   │
│  │  │  │ │ ECS Task (1 container)       │   │  │    │   │
│  │  │  │ │ - Docker Image (ECR/Public)  │   │  │    │   │
│  │  │  │ │ - Port 8000                  │   │  │    │   │
│  │  │  │ └──────────────────────────────┘   │  │    │   │
│  │  │  └────────────────────────────────────┘  │    │   │
│  │  │   Auto Scaling (1-1 instances)          │    │   │
│  │  └──────────────────────────────────────────┘    │   │
│  └──────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────┘
```

## 📋 Prerequisites

- AWS Account with appropriate permissions
- Terraform >= 1.0
- AWS CLI configured with credentials
- EC2 Key Pair created in the target region
- Docker image available (ECR or public registry)

## 🚀 Quick Start

### 1. Clone and Setup

```bash
cd terraform_academy
```

### 2. Configure Variables

Copy the example configuration and update with your values:

```bash
cp terraform.tfvars.example terraform.tfvars
```

Edit `terraform.tfvars` and provide:
- `key_name`: Your EC2 key pair name
- `docker_image`: Your ECR image URI or public Docker image
- `allowed_ip`: Your IP address (e.g., 177.249.60.131/32)

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Review Plan

```bash
terraform plan
```

### 5. Deploy

```bash
terraform apply
```

### 6. Access Your Application

After deployment completes, get the ALB DNS name:

```bash
terraform output alb_dns_name
```

Access your application at: `http://<alb_dns_name>:8000`

## 📁 Project Structure

```
.
├── main.tf                          # Root module configuration
├── variables.tf                     # Input variable definitions
├── outputs.tf                       # Output definitions
├── terraform.tfvars.example         # Example variable values
├── vpc_module/                      # VPC networking module
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
├── ecs_module/                      # ECS cluster module
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── ecs.sh
└── README.md
```

## 🔧 Modules

### VPC Module (`vpc_module/`)

Creates the networking foundation:
- VPC with configurable CIDR block
- Public subnet for ALB
- Private subnet for ECS instances
- Internet Gateway for public internet access
- Route tables and associations

**Inputs:**
- `region`: AWS region
- `project_name`: Project identifier
- `environment`: Environment name (dev, testing, prod)
- `vpc_cidr`: VPC CIDR block
- `public_subnet_cidr`: Public subnet CIDR
- `private_app_subnet_cidr`: Private subnet CIDR

**Outputs:**
- `vpc_id`: VPC identifier
- `public_subnet_id`: Public subnet identifier
- `private_app_subnet_id`: Private subnet identifier

### ECS Module (`ecs_module/`)

Manages container orchestration:
- ECS Cluster and capacity provider
- EC2 launch template with ECS-optimized AMI
- Auto Scaling Group (configurable, default 1 instance)
- Application Load Balancer with listener and target group
- ECS Task Definition (single container)
- ECS Service with load balancer integration
- Security Group with configurable ingress rules

**Inputs:**
- `allowed_ip`: IP address for security group ingress (e.g., 177.249.60.131/32)
- `key_name`: EC2 key pair name for SSH access
- `docker_image`: Docker image URI to deploy

**Outputs:**
- `ecs_cluster_id`: ECS cluster identifier
- `ecs_service_name`: ECS service name
- `alb_dns_name`: Load balancer DNS for application access
- `security_group_id`: Security group identifier

## 📝 Input Variables

### Root Module

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `region` | string | `us-east-1` | AWS region |
| `project_name` | string | `oruiz` | Project name |
| `environment` | string | `testing` | Environment name |
| `vpc_cidr` | string | `192.168.0.0/16` | VPC CIDR block |
| `public_subnet_cidr` | string | `192.168.0.0/24` | Public subnet CIDR |
| `private_app_subnet_cidr` | string | `192.168.1.0/24` | Private subnet CIDR |
| `allowed_ip` | string | `177.249.60.131/32` | Allowed IP for security group |
| `key_name` | string | (required) | EC2 key pair name |
| `docker_image` | string | `nginx:latest` | Docker image URI |

## 📤 Outputs

| Output | Description |
|--------|-------------|
| `vpc_id` | VPC identifier |
| `public_subnet_id` | Public subnet identifier |
| `private_app_subnet_id` | Private subnet identifier |
| `ecs_cluster_id` | ECS cluster identifier |
| `ecs_service_name` | ECS service name |
| `alb_dns_name` | ALB DNS name (use to access application) |
| `alb_zone_id` | ALB zone ID |
| `security_group_id` | Security group identifier |

## 🔐 Security Considerations

- **Security Group**: Restricted to a single IP address by default (configurable via `allowed_ip`)
- **Subnets**: ECS instances run in a private subnet
- **ALB**: Publicly accessible on port 8000
- **IAM**: Uses existing IAM roles (`ecsInstanceRole`, `ecsTaskExecutionRole`)

## 📊 Container Configuration

- **Instance Type**: t3.nano
- **Root Volume**: 30 GB (gp2)
- **Container Port**: 8000 (HTTP)
- **Memory**: 512 MB per task
- **CPU**: 256 CPU units
- **Network Mode**: awsvpc (requires ENI per task)

## 🛠️ Common Operations

### View Current State

```bash
terraform state list
terraform state show aws_ecs_cluster.ecs_cluster
```

### Update Docker Image

Edit `terraform.tfvars`:
```hcl
docker_image = "myecr:new-version"
```

Then apply:
```bash
terraform apply
```

### Scale Tasks

To increase desired tasks, modify the ECS service in `ecs_module/main.tf`:
```hcl
desired_count = 2  # Change from 1 to 2
```

### SSH to EC2 Instance

```bash
# Get instance ID from AWS Console or describe-instances
aws ec2 describe-instances --region us-east-1
ssh -i /path/to/key.pem ec2-user@instance-ip
```

## 🧹 Cleanup

To destroy all resources:

```bash
terraform destroy
```

This will:
- Terminate ECS tasks and services
- Delete ECS cluster
- Remove load balancer
- Delete subnets and VPC
- Remove all associated resources

⚠️ **Warning**: This action is irreversible. Ensure you have backups if needed.

## 🐛 Troubleshooting

### `Error: Unauthorized operation.iam.GetRole`
- Ensure your AWS credentials have sufficient IAM permissions
- Verify the IAM roles (`ecsInstanceRole`, `ecsTaskExecutionRole`) exist in your account

### `Error: error creating Auto Scaling Group`
- Ensure the launch template was created successfully
- Verify the subnets exist and are valid

### `Application not accessible`
- Check the ALB is in "active" state
- Verify security group allows your IP on port 8000
- Confirm ECS tasks are running in the ECS console

### `Task fails to start`
- Check CloudWatch logs in ECS cluster
- Verify Docker image URI is correct and accessible
- Ensure container port 8000 is available

## 📚 References

- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS ECS Documentation](https://docs.aws.amazon.com/ecs/)
- [AWS VPC Documentation](https://docs.aws.amazon.com/vpc/)

## 📄 License

This project is part of Terraform Academy training materials.