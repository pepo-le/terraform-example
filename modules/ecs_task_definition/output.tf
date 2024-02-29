output "arn" {
  value = aws_ecs_task_definition.task_definition.arn
}

output "name" {
  value = jsondecode(aws_ecs_task_definition.task_definition.container_definitions)[0].name
}
