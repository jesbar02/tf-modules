output "iam_service_role_arn" {
  value = element(concat(aws_iam_role.service.*.arn, [""]), 0)
}

output "iam_instance_role_arn" {
  value = element(concat(aws_iam_role.instance.*.arn, [""]), 0)
}

output "iam_event_role_arn" {
  value = element(concat(aws_iam_role.event.*.arn, [""]), 0)
}

output "alb_public_arn" {
  value = element(compact(concat([module.public_alb.arn], ["-"])), 0)
}

output "alb_public_dns_name" {
  value = element(compact(concat([module.public_alb.dns_name], ["-"])), 0)
}

output "alb_public_zone_id" {
  value = element(compact(concat([module.public_alb.zone_id], ["-"])), 0)
}

output "alb_https_public_listener_arn" {
  value = element(compact(concat([module.public_alb.https_arn], ["-"])), 0)
}

output "alb_private_arn" {
  value = element(compact(concat([module.private_alb.arn], ["-"])), 0)
}

output "alb_private_dns_name" {
  value = element(compact(concat([module.private_alb.dns_name], ["-"])), 0)
}

output "alb_private_zone_id" {
  value = element(compact(concat([module.private_alb.zone_id], ["-"])), 0)
}

output "alb_https_private_listener_arn" {
  value = element(compact(concat([module.private_alb.https_arn], ["-"])), 0)
}

output "cluster_name" {
  value = "${var.project}-${terraform.workspace}"
}

output "cluster_ids" {
  value = aws_ecs_cluster.this.*.id
}

output "aws_region" {
  value = var.aws_region
}

output "ecr_url" {
  value = element(compact(concat([module.ecr.url], ["-"])), 0)
}

output "ec2_ami" {
  value = var.ec2_ami == "" ? data.aws_ami.ecs[0].id : var.ec2_ami
}

output "alb_public_arn_suffix" {
  value = element(compact(concat([module.public_alb.arn_suffix], ["-"])), 0)
}

output "alb_private_arn_suffix" {
  value = element(compact(concat([module.private_alb.arn_suffix], ["-"])), 0)
}
