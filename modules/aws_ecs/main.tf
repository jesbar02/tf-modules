resource "aws_ecs_cluster" "this" {
  count = length(var.cluster_names) > 0 ? length(var.cluster_names) : 0
  name  = var.cluster_names[count.index]

  capacity_providers = [var.cluster_names[count.index]]

  depends_on = [aws_ecs_capacity_provider.capacity_provider]
}

module "ecr" {
  create       = var.create ? var.ecr : false
  source       = "../aws_ecr"
  project      = var.project
  tag_prefixes = var.tag_prefixes
}

# AutoScaling Group
module "asg" {
  source                               = "../aws_asg"
  create                               = var.create
  project                              = var.project
  ami                                  = var.ec2_ami == "" ? data.aws_ami.ecs[0].id : var.ec2_ami
  instance_types                       = var.ec2_instance_types
  key_name                             = var.ec2_key_name
  enable_monitoring                    = var.ec2_enable_monitoring
  subnet_ids                           = var.vpc_ec2_subnet_ids
  security_groups                      = var.ec2_security_group_ids
  iam_instance_role_name               = aws_iam_instance_profile.instance[0].name
  min_sizes                            = var.asg_min_sizes
  max_sizes                            = var.asg_max_sizes
  sizes                                = var.asg_sizes
  sleep_time                           = 150
  draining_process_lambda_timeout      = var.draining_process_lambda_timeout
  draining_process_logs_retantion_days = var.draining_process_logs_retantion_days
  draining_process_lifecycle_timeout   = var.draining_process_lifecycle_timeout
  scale_in_protection                  = var.scale_in_protection
  root_block_device_size               = var.ec2_root_block_device_size
  cluster_names                        = var.cluster_names
  ec2_admin_users                      = var.ec2_admin_users
  ec2_dev_users                        = var.ec2_dev_users
  aws_region                           = var.aws_region
}

module "public_alb" {
  source                   = "../aws_alb"
  create                   = var.create ? var.alb_public : false
  project                  = var.project
  security_group_ids       = var.alb_public_security_group_ids
  subnet_ids               = var.vpc_public_subnet_ids
  acm_public_arn           = var.acm_public_arn
  acm_public_alternate_arn = var.acm_public_alternate_arn
  ssl_policy               = var.ssl_policy
}

module "private_alb" {
  source                    = "../aws_alb"
  create                    = var.create ? var.alb_private : false
  project                   = var.project
  private                   = var.alb_private
  security_group_ids        = var.alb_private_security_group_ids
  subnet_ids                = var.vpc_private_subnet_ids
  acm_private_arn           = var.acm_private_arn
  acm_private_alternate_arn = var.acm_private_alternate_arn
  ssl_policy                = var.ssl_policy
}
