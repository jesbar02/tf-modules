# AWS ECS

Description

## Usage

### Saasler example

- You can check a full implementation at [`saasler_core`](https://github.com/koombea/saasler_core/blob/develop/deploy/terraform/base/main.tf) repo :P

## Variables

| Name                             |  Default   | Description                                                                                                | Required |
| :------------------------------- | :--------: | :--------------------------------------------------------------------------------------------------------- | :------: |
| `create`                         |   `true`   | Module optional execution (`true` or `false`)                                                              |    No    |
| `project`                        |            | Project (e.g. `flightlogger`, `saasler`)                                                                   |   Yes    |
| `aws_region`                     |            |  VPC Region                                                                                                |   Yes    |
| `cloudwatch_logs_retention_days` |    `30`    | CloudWatch Log group retention period in days                                                              |    No    |
| `ecr`                            |  `false`   | Optional ECR Registry                                                                                      |    No    |
| `alb_public`                     |   `true`   | Add an public ALB?                                                                                         |    No    |
| `alb_public_security_group_ids`  |            | List of VPC security groups ids to associate with public ALB                                               |   Yes    |
| `alb_private`                    |  `false`   | Add an internal ALB? (If `true`, `alb_private_security_group_ids` can't be empty)                          |    No    |
| `alb_private_security_group_ids` |    `[]`    | List of VPC security groups ids to associate with public ALB                                               |    No    |
| `acm_arn`                        |            | ACM Certificate to use for ALB HTTPS Listeners                                                             |   Yes    |
| `acm_arn_alternate`              |    `[]`    | Additional ACM Certificates to use for public ALB HTTPS Listener                                           |    No    |
| `ec2_key_name`                   |            | [EC2 Key Pair name](https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#KeyPairs:sort=keyName)     |   Yes    |
| `ec2_admin_users`                |            | Space seppareted value with github usernames (`user1 user2`). Access to `docker` and `sudo`                |   Yes    |
| `ec2_dev_users`                  |            | Space seppareted value with github usernames (`user3 user4`). Only access to `docker` for non-prod envs    |   Yes    |
| `ec2_packages`                   |   `vim`    |  Optional packages to install at EC2 instance creation time (e.g. `vim curl wget`)                         |    No    |
| `ec2_instance_type`              | `t3.small` | EC2 [Instance type](https://aws.amazon.com/ec2/instance-types/)                                            |    No    |
| `ec2_enable_monitoring`          |  `true`    | [EC2 monitoring](https://docs.aws.amazon.com/autoscaling/ec2/userguide/as-instance-monitoring.html)        |    No    |
| `ec2_volume_type`                |   `gp2`    | EC2 [volume type](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSVolumeTypes.html)                 |    No    |
| `ec2_root_block_device_size`     |    `8`     | [Root devise size](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/block-device-mapping-concepts.html) |    No    |
| `ec2_security_group_ids`         |            | List of VPC security groups ids to associate with EC2 instances                                            |   Yes    |
| `vpc_ec2_subnet_ids`             |            | List of VPC Subnet ids for ASG                                                                             |   Yes    |
| `vpc_public_subnet_ids`          |            | List of VPC public subnet ids                                                                              |   Yes    |
| `vpc_private_subnet_ids`         |            | List of VPC private subnet ids                                                                             |   Yes    |
| `asg_min_size`                   |    `0`     | ASG minimum size                                                                                           |    No    |
| `asg_max_size`                   |    `3`     | ASG maximum size                                                                                           |    No    |
| `asg_size`                       |    `1`     | ASG desired size                                                                                           |    No    |
| `asg_index`                      |    `0`     | Incremental number to append at the end of Launch Configuration and ASG names which must be uniques        |    No    |

## Outputs

| Name                             | Description                                                                                           |
| :------------------------------- | :---------------------------------------------------------------------------------------------------- |
| `cluster_name`                   | ECS Cluster name (e.g. `saasler-staging`, `flightlogger-core-production`)                             |
| `cluster_id`                     | ECS Cluster ARN                                                                                       |
| `aws_region`                     | AWS Region (e.g. `us-east-1`, `us-west-2`)                                                            |
| `ecr_url`                        | AWS ECR container registry URL (e.g. `321401415660.dkr.ecr.us-east-1.amazonaws.com/saasler-staging` ) |
| `ec2_ami`                        | EC2 AMI currently used by cluster nodes (`ami-0254e5972ebcd132c`)                                     |
| `iam_service_role_arn`           |                                                                                                       |
| `iam_instance_role_arn`          |                                                                                                       |
| `iam_event_role_arn`             |                                                                                                       |
| `alb_public_arn`                 | Public ALB ARN                                                                                        |
| `alb_public_dns_name`            | Public ALB DNS name                                                                                   |
| `alb_public_zone_id`             | Public ALB canonical hosted zone ID                                                                   |
| `alb_https_public_listener_arn`  | Public ALB HTTPS Listener ARN                                                                         |
| `alb_private_arn`                | Private ALB ARN                                                                                       |
| `alb_private_dns_name`           | Private ALB DNS name                                                                                  |
| `alb_private_zone_id`            | Private ALB canonical hosted zone ID                                                                  |
| `alb_https_private_listener_arn` | Private ALB HTTPS Listener ARN                                                                        |
