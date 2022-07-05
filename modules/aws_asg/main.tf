data "template_file" "user_data" {
  count    = length(var.cluster_names) > 0 ? length(var.cluster_names) : 0
  template = file("${path.module}/user-data.sh")

  vars = {
    ecs_cluster_name = var.cluster_names[count.index]
    ec2_admin_users  = join(" ", var.ec2_admin_users)
    ec2_dev_users    = join(" ", var.ec2_dev_users)
    aws_region       = var.aws_region
  }
}

resource "aws_launch_template" "this" {
  count         = length(var.cluster_names) > 0 ? length(var.cluster_names) : 0
  name          = var.cluster_names[count.index]
  image_id      = var.ami
  instance_type = var.instance_types[count.index]
  user_data     = base64encode(data.template_file.user_data[count.index].rendered)
  key_name      = var.key_name

  iam_instance_profile {
    name = var.iam_instance_role_name
  }

  monitoring {
    enabled = true
  }

  vpc_security_group_ids = var.security_groups

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      encrypted   = true
      volume_type = var.volume_type
      volume_size = var.root_block_device_size
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "this" {
  count = length(var.cluster_names) > 0 ? length(var.cluster_names) : 0
  name  = var.cluster_names[count.index]

  capacity_rebalance = true

  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                  = 0
      on_demand_percentage_above_base_capacity = 0
      spot_allocation_strategy                 = "lowest-price"
      spot_instance_pools                      = 20
    }

    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.this[count.index].id
        version            = "$Latest"
      }

      override {
        instance_type = var.instance_types[count.index]
      }
    }
  }

  termination_policies = ["OldestInstance"]

  vpc_zone_identifier = var.subnet_ids

  min_size         = var.min_sizes[count.index]
  max_size         = var.max_sizes[count.index]
  desired_capacity = var.sizes[count.index]

  protect_from_scale_in = var.scale_in_protection

  health_check_grace_period = var.health_check_grace_period

  provisioner "local-exec" {
    command = "sleep ${var.sizes[count.index] > 0 ? var.sleep_time : 0}"
  }

  tag {
    key                 = "Name"
    value               = "${var.cluster_names[count.index]}-node"
    propagate_at_launch = true
  }

  tag {
    key                 = "project"
    value               = var.project
    propagate_at_launch = true
  }

  tag {
    key                 = "environment"
    value               = terraform.workspace
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_lifecycle_hook" "this" {
  count                  = length(var.cluster_names) > 0 ? length(var.cluster_names) : 0
  name                   = "${aws_autoscaling_group.this[count.index].name}-draining-process"
  autoscaling_group_name = var.cluster_names[count.index]
  default_result         = "ABANDON"
  heartbeat_timeout      = var.draining_process_lifecycle_timeout
  lifecycle_transition   = "autoscaling:EC2_INSTANCE_TERMINATING"
}
