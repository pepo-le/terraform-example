# Application Auto Scalingの設定
resource "aws_appautoscaling_target" "ecs_target" {
  resource_id        = "service/${var.cluster_name}/${var.service_name}"
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# スケーリングポリシーの設定
resource "aws_appautoscaling_policy" "ecs_policy" {
  name               = var.scaling_policy_name
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value       = var.target_cpu_utilization
    scale_in_cooldown  = var.scale_in_cooldown
    scale_out_cooldown = var.scale_out_cooldown
  }

  depends_on = [aws_appautoscaling_target.ecs_target]
}
