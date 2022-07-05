# AWS ALB

Creates an public or private [Application Load Balancer](https://docs.aws.amazon.com/elasticloadbalancing/latest/application/introduction.html)

## Usage

### Example 1

- Public ALB
- Private ALB

```hcl
module "vpc" {
  source = "git::git@github.com:koombea/terraform_modules//aws_vpc"
  ...
}

module "acm" {
  source = "git::git@github.com:koombea/terraform_modules//aws_acm"
  ...
}

module "sg" {
  source = "git::git@github.com:koombea/terraform_modules//aws_sg"
  ..
}

module "public" {
  source             = "git::git@github.com:koombea/terraform_modules//aws_alb"
  project            = "${var.project}"
  security_group_ids = ["${module.sg.id}"]
  subnet_ids         = ["${module.vpc.public_subnet_ids}"]
  acm_arn            = "${module.acm.arn}"
}

module "private" {
  source             = "git::git@github.com:koombea/terraform_modules//aws_alb"
  project            = "${var.project}"
  private            = true
  security_group_ids = ["${module.sg.id}"]
  subnet_ids         = ["${module.vpc.private_subnet_ids}"]
  acm_arn            = "${module.acm.arn}"
}
```

## Variables

| Name                 | Default | Description                                   | Required |
| :------------------- | :-----: | :-------------------------------------------- | :------: |
| `create`             |  `true` | Module optional execution (`true` or `false`) |    No    |
| `project`            |         | Project (e.g. `flightlogger`, `saasler`)      |   Yes    |
| `private`            | `false` | Internal ALB? (`true` or `false`)             |    No    |
| `security_group_ids` |         | List of VPC security groups ids to associate  |   Yes    |
| `subnet_ids`         |         | List of VPC Subnet ids                        |   Yes    |
| `acm_arn`            |         | ARN Certificate for HTTPS Listener            |   Yes    |
| `acm_arn_alternate`  |   []    | Additional ARN Certificate for HTTPS Listener |    No    |

## Outputs

| Name        | Description                                                                           |
| :---------- | :------------------------------------------------------------------------------------ |
| `arn`       | ALB ARN                                                                               |
| `dns_name`  | ALB DNS name                                                                          |
| `zone_id`   | Canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record) |
| `https_arn` | HTTPS Listener ARN                                                                    |
