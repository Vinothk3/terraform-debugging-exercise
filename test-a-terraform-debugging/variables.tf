variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "us-west-2"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "main-vpc"
}

variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
  default     = "main-cluster"
}

variable "container_image" {
  description = "Docker image for the web app"
  type        = string
  default     = "nginx:latest"
}

variable "app_port" {
  description = "Port the application listens on"
  type        = number
  default     = 80
}

variable "desired_count" {
  description = "Desired number of ECS tasks"
  type        = number
  default     = 2
}
