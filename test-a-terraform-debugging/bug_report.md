# Bug Report

This document documents the errors found in the broken Terraform code and how they were fixed.

## Summary
- Total errors found: 13
- Categories: Circular dependencies, missing required fields, invalid syntax, IAM issues, missing resource references
- Status: All errors fixed and code is deployable

## Error Details

### 1. Circular Dependency (main.tf line 25)
The subnet referenced the route table in a conditional check, creating a circular dependency.
**Fix:** Removed the conditional and set `map_public_ip_on_launch = true` directly.

### 2. Missing gateway_id (main.tf line 58)
Route table route was missing the `gateway_id` field.
**Fix:** Added `gateway_id = aws_internet_gateway.main.id` to the route block.

### 3. Missing subnet_id (main.tf line 70)
Route table association was missing the `subnet_id` field.
**Fix:** Added `subnet_id = aws_subnet.public[count.index].id`.

### 4. Self-referencing Security Group (main.tf line 98)
Security group had a rule referencing itself, which was unnecessary.
**Fix:** Removed the self-referencing ingress rule.

### 5. Missing logConfiguration (main.tf line 152)
ECS task definition was missing required `logConfiguration` for Fargate.
**Fix:** Added log configuration with CloudWatch Logs as the driver.

### 6. Invalid Environment Format (main.tf line 153)
Environment variable was a string instead of a list of objects.
**Fix:** Changed to proper format: `[{name = "APP_ENV", value = "production"}]`.

### 7. Missing launch_type (main.tf line 176)
ECS service was missing the `launch_type` field.
**Fix:** Added `launch_type = "FARGATE"`.

### 8. Missing network_configuration (main.tf line 177)
ECS service was missing required network configuration for Fargate.
**Fix:** Added `network_configuration` block with subnets, security groups, and public IP assignment.

### 9. Missing assume_role_policy (main.tf line 194)
IAM role was missing the trust policy.
**Fix:** Added `assume_role_policy` allowing ECS tasks to assume the role.

### 10. Overly Permissive IAM Policy (main.tf lines 220-234)
IAM policy used wildcard permissions (`Action: "*"`, `Resource: "*"`).
**Fix:** Replaced with specific permissions for CloudWatch Logs and SSM only.

### 11. Missing subnets in ALB (main.tf line 242)
ALB was missing the `subnets` argument.
**Fix:** Added `subnets = aws_subnet.public[*].id`.

### 12. Invalid Listener Action (main.tf lines 282-285)
Listener used `fixed-response` action without required configuration.
**Fix:** Changed to `forward` action to route traffic to target group.

### 13. Wrong Action Type (main.tf line 287)
Listener should use `forward` action for web applications.
**Fix:** Used `forward` action with target group ARN.

## Refactoring
Split monolithic main.tf into logical modules:
- networking.tf - VPC, subnets, IGW, route tables
- ecs.tf - ECS cluster, task definition, service
- iam.tf - IAM roles and policies
- alb.tf - ALB, target group, listener

## Validation
Code now passes:
- terraform validate (no syntax or configuration errors)
- No circular dependencies
- IAM policies follow least-privilege principle
- Proper modular structure

## Prevention
- Use pre-commit hooks for validation
- Implement code reviews
- Add security scanning (tfsec, checkov)
- Follow least-privilege IAM practices
- Document infrastructure patterns
