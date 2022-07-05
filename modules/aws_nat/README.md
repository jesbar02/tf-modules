# AWS Nat Gateway

It creates an AWS [NAT Gateway](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html) for an existing VPC using a public subnet and a private route table.

## Usage

### Example 1:

- Add a NAT Gateway for a previous VPC

```hcl
module "vpc" {
  source      = "git::git@github.com:koombea/terraform_modules//aws_vpc"
  project     = "${var.project}"
  ...
}

module "nat_gateway" {
  source                 = "git::git@github.com:koombea/terraform_modules//aws_nat"
  project                = "${var.project}"
  public_subnet_ids      = "${module.vpc.public_subnet_ids[0]}"
  private_route_table_id = "${module.vpc.private_route_table_id}"
}
```

### Example 2:

- Create a VPC with a NAT Gateway using the `nat_gateway` flag from `aws_vpc` module

```hcl
module "vpc" {
  source      = "git::git@github.com:koombea/terraform_modules//aws_vpc"
  project     = "${var.project}"
  nat_gateway = true
  ...
}
```

There is an internal reference for `aws_nat` from `aws_vpc` module.

## Variables

| Name                     | Default | Description                                                        | Required |
| :----------------------- | :-----: | :----------------------------------------------------------------- | :------: |
| `create`                 |  `true` | Module optional execution (`true` or `false`)                      |    No    |
| `project`                |         | Project (e.g. `flightlogger`, `saasler`)                           |   Yes    |
| `public_subnet_id`       |         | Public subnet id (e.g. `"subnet-6a89d441","subnet-6bcef930", etc`) |   Yes    |
| `private_route_table_id` |         | VPC Private route table (e.g. `rtb-0224485e6382e94d3`)             |   Yes    |

## Outputs

| Name | Description                                   |
| :--- | :-------------------------------------------- |
| `id` | NAT Gateway id (e.g. `nat-0da69aafcbaf2dc13`) |
| `ip` | NAT Gateway public IP                         |
