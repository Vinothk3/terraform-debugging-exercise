# Web Application Stack - Terraform

This Terraform configuration deploys a web application stack on AWS using ECS Fargate, Application Load Balancer, and VPC networking.

## Architecture

Deploys:
- VPC with public and private subnets across 2 AZs
- Internet Gateway and route tables
- ECS Fargate cluster with containerized web app
- Application Load Balancer
- Security groups for HTTP/HTTPS
- IAM roles with least-privilege policies
- CloudWatch log group

## Prerequisites

- Terraform >= 1.5.0
- AWS CLI configured with credentials
- AWS account with permissions to create VPC, ECS, ALB, IAM resources

## Installation

```bash
# Copy example variables
cp terraform.tfvars.example terraform.tfvars

# Edit with your values
# aws_region, environment, vpc_name, cluster_name, container_image, app_port, desired_count

# Initialize Terraform
terraform init
```

## Deployment

```bash
# Plan deployment
terraform plan

# Apply changes
terraform apply
```

## Testing

```bash
# Get ALB DNS name
ALB_DNS=$(terraform output -raw alb_dns_name)

# Test HTTP endpoint
curl http://$ALB_DNS

# Test health endpoint
curl http://$ALB_DNS/health
```

## Variables

| Variable | Description | Type | Default |
|----------|-------------|------|---------|
| aws_region | AWS region | string | us-west-2 |
| environment | Environment name | string | dev |
| vpc_name | VPC name | string | main-vpc |
| cluster_name | ECS cluster name | string | main-cluster |
| container_image | Docker image | string | nginx:latest |
| app_port | App port | number | 80 |
| desired_count | Number of tasks | number | 2 |

## Outputs

- vpc_id - VPC ID
- alb_dns_name - Load balancer DNS name
- ecs_cluster_name - ECS cluster name
- ecs_service_name - ECS service name
- public_subnet_ids - Public subnet IDs
- private_subnet_ids - Private subnet IDs
- target_group_arn - Target group ARN

## Destruction

```bash
terraform destroy
```

## Troubleshooting

### Terraform Init Fails
Check internet connection and proxy settings

### Plan Shows Errors
Run `terraform validate` to identify syntax errors

### Apply Fails with Permissions Error
Ensure AWS credentials have necessary permissions

### ECS Tasks Not Starting
Check CloudWatch logs, verify task definition, ensure security groups allow traffic

### ALB Health Checks Failing
Verify application is listening on correct port, check security groups, review health check config

## File Structure

```
test-a-terraform-debugging/
├── README.md
├── bug_report.md
├── providers.tf
├── variables.tf
├── terraform.tfvars.example
├── networking.tf
├── ecs.tf
├── iam.tf
├── alb.tf
├── outputs.tf
└── .gitignore
```

## Customization

### Change Container Image
Edit terraform.tfvars:
```hcl
container_image = "your-registry/your-image:tag"
```

### Scale Application
Edit terraform.tfvars:
```hcl
desired_count = 4
```

### Change Resource Sizes
Modify cpu and memory in ecs.tf
