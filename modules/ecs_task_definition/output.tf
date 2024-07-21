output "arn" {
  value = aws_ecs_task_definition.main.arn
}

output "name" {
  value = jsondecode(aws_ecs_task_definition.main.container_definitions)[0].Name
}
