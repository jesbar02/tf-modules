# AWS ASG

Creates a [Launch Configuration](https://docs.aws.amazon.com/autoscaling/ec2/userguide/LaunchConfiguration.html) and [Auto Scaling Group](https://docs.aws.amazon.com/autoscaling/plans/userguide/what-is-aws-auto-scaling.html).

**NOTE**: For now it only supports ASG for ECS usage.

## Usage

### Example 1

- Create an Auto Scaling Group for ECS Usage (Example from [`aws_ecs`](https://github.com/koombea/terraform_modules/tree/master/aws_ecs) module)

```hcl
...
data "template_file" "user_data" {
  template = "${file("${path.module}/user-data.sh")}"

  vars {
    ecs_cluster_name = "${var.project}-${terraform.workspace}"
    ec2_admin_users  = "${var.ec2_admin_users}"
    ec2_dev_users    = "${var.ec2_dev_users}"
    ec2_packages     = "${var.ec2_packages}"
  }
}

module "asg" {
  source                = "../aws_asg"
  create                = "${var.create}"
  project               = "${var.project}"
  ami                   = "${var.ec2_ami==""? data.aws_ami.ecs.id : var.ec2_ami}"
  instance_type         = "${var.ec2_instance_type}"
  user_data             = "${data.template_file.user_data.rendered}"
  key_name              = "${var.ec2_key_name}"
  enable_monitoring     = "${var.ec2_enable_monitoring}"
  subnet_ids            = ["${var.vpc_ec2_subnet_ids}"]
  security_groups       = ["${var.ec2_security_groups}"]
  iam_instance_role_arn = "${aws_iam_instance_profile.instance.id}"
  min_size              = "${var.asg_min_size}"
  max_size              = "${var.asg_max_size}"
  size                  = "${var.asg_size}"
  index                 = "${var.asg_index}"
  sleep_time            = 150
}
...
```

## Variables

| Name                        |  Default   | Description                                                                                                                                                       | Required |
| :-------------------------- | :--------: | :---------------------------------------------------------------------------------------------------------------------------------------------------------------- | :------: |
| `create`                    |   `true`   | Module optional execution (`true` or `false`)                                                                                                                     |    No    |
| `project`                   |            | Project (e.g. `flightlogger`, `saasler`)                                                                                                                          |   Yes    |
| `ami`                       |            | EC2 [AMI](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html)                                                                                          |   Yes    |
| `instance_type`             | `t3.small` | EC2 [Instance type](https://aws.amazon.com/ec2/instance-types/)                                                                                                   |    No    |
| `user_data`                 |            | Rendered `user_data` [[1]](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/user-data.html)[[2]](https://www.terraform.io/docs/providers/template/d/file.html) |   Yes    |
| `key_name`                  |            | [EC2 Key Pair name](https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#KeyPairs:sort=keyName)                                                            |   Yes    |
| `enable_monitoring`         |  `true`    | [EC2 monitoring](https://docs.aws.amazon.com/autoscaling/ec2/userguide/as-instance-monitoring.html)                                                               |    No    |
| `subnet_ids`                |            | Litt of VPC Subnet ids                                                                                                                                            |   Yes    |
| `security_group_ids`        |            | List of VPC security groups ids to associate                                                                                                                      |   Yes    |
| `health_check_grace_period` |    `0`     | [EC2 Health Check grace time](https://docs.aws.amazon.com/autoscaling/ec2/userguide/healthcheck.html) in seconds                                                  |    No    |
| `iam_instance_role_arn`     |            | EC2 instances [IAM Role](https://docs.aws.amazon.com/autoscaling/ec2/userguide/us-iam-role.html)                                                                  |   Yes    |
| `min_size`                  |    `0`     | ASG minimum size                                                                                                                                                  |    No    |
| `max_size`                  |    `3`     | ASG maximum size                                                                                                                                                  |    No    |
| `size`                      |    `1`     | ASG desired size                                                                                                                                                  |    No    |
| `index`                     |    `0`     | Incremental number to append at the end of Launch Conf. and ASG names which need to be uniques                                                                    |    No    |
| `sleep_time`                |    `0`     | Optional sleep time (through `local-exec` provisioner) to wait initial config before delete old resources                                                         |    No    |
| `volume_type`               |   `gp2`    | EC2 [volume type](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/EBSVolumeTypes.html)                                                                        |    No    |
| `root_block_device_size`    |    `8`     | [Root devise size](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/block-device-mapping-concepts.html)                                                        |    No    |

## Outputs

| Name   | Description                     |
| :----- | :------------------------------ |
| `name` | The name of the autoscale group |
