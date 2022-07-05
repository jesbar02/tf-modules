resource "aws_appautoscaling_target" "ecs_autoscaling_target" {
  max_capacity       = var.autoscaling_max_capacity
  min_capacity       = var.autoscaling_min_capacity
  resource_id        = "service/${split("/", var.cluster_id)[1]}/${var.service_name}-${terraform.workspace}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  depends_on = [aws_ecs_service.this]
}

resource "aws_appautoscaling_policy" "ecs_autoscaling_policy_memory" {
  name               = "${var.project}-${var.service_name}-${terraform.workspace}-memory-ecs-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = "service/${split("/", var.cluster_id)[1]}/${var.service_name}-${terraform.workspace}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }

    target_value       = var.autoscaling_memory_target_value
    scale_in_cooldown  = 300
    scale_out_cooldown = 0
  }

  depends_on = [aws_appautoscaling_target.ecs_autoscaling_target, aws_ecs_service.this]
  lifecycle {
    create_before_destroy = true
  }
}
