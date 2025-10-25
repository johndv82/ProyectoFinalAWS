resource "aws_ecr_repository" "app_repo" {
  name = var.project
}


resource "aws_ecs_cluster" "cluster" {
  name = "${var.project}-cluster"
}


resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/${var.project}"
  retention_in_days = 14
}


resource "aws_ecs_task_definition" "task" {
  family                   = "${var.project}-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn


  container_definitions = jsonencode([
    {
      name      = "${var.project}-container"
      image     = "${aws_ecr_repository.app_repo.repository_url}:latest"
      essential = true
      portMappings = [
        { containerPort = 3000, protocol = "tcp" }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs_log_group.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = var.project
        }
      }
    }
  ])
}


resource "aws_ecs_service" "service" {
  name            = "${var.project}-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 1
  launch_type     = "FARGATE"


  network_configuration {
    subnets          = aws_subnet.public[*].id
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }


  # load_balancer {
  #   target_group_arn = aws_lb_target_group.app_tg.arn
  #   container_name   = "${var.project}-container"
  #   container_port   = 3000
  # }


  # depends_on = [aws_lb_listener.front_end]

}
