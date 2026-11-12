resource "aws_cloudwatch_log_group" "web_app" {
  name              = "/ecs/web-app"
  retention_in_days = 7
  tags = {
    Name = "web-app-logs"
  }
}

resource "aws_ecs_cluster" "main" {
  name = var.cluster_name
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
  tags = {
    Name = var.cluster_name
  }
}

resource "aws_ecs_task_definition" "web" {
  family                   = "web-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_execution.arn
  task_role_arn            = aws_iam_role.ecs_task.arn

  container_definitions = jsonencode([
    {
      name      = "web"
      image     = var.container_image
      essential = true
      portMappings = [{
        containerPort = var.app_port
        hostPort      = var.app_port
        protocol      = "tcp"
      }]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/web-app"
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
      environment = [{
        name  = "APP_ENV"
        value = "production"
      }]
      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost/health || exit 1"]
        interval    = 30
        timeout     = 5
        retries     = 3
        startPeriod = 60
      }
    }
  ])
  tags = {
    Name = "web-app"
  }
}

resource "aws_ecs_service" "web" {
  name            = "web-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.web.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"
  network_configuration {
    subnets          = aws_subnet.public[*].id
    security_groups  = [aws_security_group.web.id]
    assign_public_ip = true
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.web.arn
    container_name   = "web"
    container_port   = var.app_port
  }
  depends_on = [aws_lb_listener.web]
}
