resource "aws_ecs_capacity_provider" "capacity_provider" {
  count = length(var.cluster_names) > 0 ? length(var.cluster_names) : 0
  name  = var.cluster_names[count.index]

  auto_scaling_group_provider {
    auto_scaling_group_arn         = module.asg.arn[count.index]
    managed_termination_protection = var.managed_termination_protection

    managed_scaling {
      maximum_scaling_step_size = var.max_scaling_step
      minimum_scaling_step_size = var.min_scaling_step
      status                    = "ENABLED"
      target_capacity           = var.target_capacity
    }
  }
}
