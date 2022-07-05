# AWS Subnet

Creates a single subnet within a previous VPC (`vpc_id`)

## Usage

Creating 2 public subnets and 1 private subnet within a previous VPC

```hcl
module "vpc" {
  source = "git::git@github.com:koombea/terraform_modules//aws_vpc"
  ...
}

data "aws_availability_zones" "available" {}

module "public_subnet_00" {
  source            = "git::git@github.com:koombea/terraform_modules//aws_net"
  project           = "${var.project}"
  public            = true
  cidr_block        = "10.0.0.0/24"
  vpc_id            = "${module.vpc.id}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
}

module "public_subnet_01" {
  source            = "git::git@github.com:koombea/terraform_modules//aws_net"
  project           = "${var.project}"
  cidr_block        = "10.0.1.0/24"
  vpc_id            = "${module.vpc.id}"
  availability_zone = "${data.aws_availability_zones.available.names[1]}"
}

module "private_subnet_00" {
  source            = "git::git@github.com:koombea/terraform_modules//aws_net"
  project           = "${var.project}"
  public            = false
  cidr_block        = "10.0.100.0/24"
  vpc_id            = "${module.vpc.id}"
  availability_zone = "${data.aws_availability_zones.available.names[0]}"
}
```

## Variables

| Name                | Default | Description                                               | Required |
| :------------------ | :-----: | :-------------------------------------------------------- | :------: |
| `create`            |  `true` | Module optional execution (`true` or `false`)             |    No    |
| `project`           |         | Project (e.g. `flightlogger`, `saasler`)                  |   Yes    |
| `cidr_block`        |         | Subnet CIDR block (e.g. `10.0.0.0/24`, `192.168.0.0/24`)  |   Yes    |
| `vpc_id`            |         | VPC ID (e.g. `vpc-5616fe2c`)                              |   Yes    |
| `public`            | `true`  | Use Public or Private VPC Route table (`true` or `false`) |    No    |
| `availability_zone` |         | Sunet Availability Zone (e.g. `us-east-1b`, `us-west-2c`) |   Yes    |

## Outputs

| Name | Description                        |
| :--- | :--------------------------------- |
| `id` | Subnet id (e.g. `subnet-b99d8de0`) |
