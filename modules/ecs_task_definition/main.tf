resource "aws_ecs_task_definition" "task_definition" {
  family                   = var.task_definition_family
  network_mode             = var.network_mode
  requires_compatibilities = var.requires_compatibilities
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = var.execution_role_arn
  tags = {
    "Name" = var.task_definition_family
  }

  container_definitions = var.container_definitions
}
