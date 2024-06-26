resource "aws_ecs_task_definition" "main" {
  family                   = var.task_definition_family
  network_mode             = var.network_mode
  requires_compatibilities = var.requires_compatibilities
  cpu                      = var.cpu
  memory                   = var.memory
  task_role_arn            = var.task_role_arn
  execution_role_arn       = var.execution_role_arn
  tags = {
    "Name" = var.task_definition_family
  }

  container_definitions = var.container_definitions
}
