terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Backend configuration (S3)
  # Uncomment and configure for your environment
  # backend "s3" {
  #   bucket         = "terraform-state-bucket"
  #   key            = "web-app/terraform.tfstate"
  #   region         = "us-west-2"
  #   encrypt        = true
  #   dynamodb_table = "terraform-locks"
  # }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "web-app"
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}
