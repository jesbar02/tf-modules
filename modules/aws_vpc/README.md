# AWS VPC

It creates an AWS VPC with provided public(`public_subnets`) and private(`private_subnets`) subnets. It handles the creation of basic AWS resources like:

- Default security group: Takes the VPC default security group into IaC as an output. It can be used as an input for other modules ([`aws_sg`](https://github.com/koombea/terraform_modules/tree/master/aws_sg)).
- Internet gateway: Allows communication between resources within the VPC public subnets (using the default routing table) and the Internet.
- [NAT Gateway](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html) (Optional): Enable EC2 instances in a private subnet to connect to the internet. It uses the [`aws_nat`](https://github.com/koombea/terraform_modules/tree/master/aws_nat) module.

## Usage

### Example 1:

- Custom VPC with CIDR block `10.0.0.0/16`
- Multi-AZ deployment with 3 public subnets

```hcl
module "vpc" {
  source         = "git::git@github.com:koombea/terraform_modules//aws_vpc"
  project        = "${var.project}"
  cidr_block     = "10.0.0.0/16"
  public_subnets = ["10.0.0.0/24","10.0.1.0/24","10.0.2.0/24"]
}
```

### Example 2:

- Custom VPC with CIDR block `10.0.0.0/16`
- 3 public subnets
- 2 private subnets

```hcl
module "vpc" {
  source          = "git::git@github.com:koombea/terraform_modules//aws_vpc"
  project         = "${var.project}"
  cidr_block      = "10.0.0.0/16"
  public_subnets  = ["10.0.0.0/24","10.0.1.0/24","10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24","10.0.4.0/24"]
}
```

### Example 3:

- Custom VPC with CIDR block `10.1.0.0/16`
- 3 public subnets
- 3 private subnets
- NAT Gateway

```hcl
module "vpc" {
  source          = "git::git@github.com:koombea/terraform_modules//aws_vpc"
  project         = "${var.project}"
  nat_gateway     = true
  cidr_block      = "10.1.0.0/16"
  public_subnets  = ["10.1.0.0/24","10.1.1.0/24","10.1.2.0/24"]
  private_subnets = ["10.1.100.0/24","10.1.101.0/24","10.1.102.0/24"]
}
```

## Variables

| Name                   | Default | Description                                                              | Required |
| :--------------------- | :-----: | :----------------------------------------------------------------------- | :------: |
| `project`              |         | Project (e.g. `flightlogger`, `saasler`)                                 |   Yes    |
| `cidr_block`           |         | CIDR block (e.g. `10.0.0.0/16`, `192.168.0.0/16`)                        |   Yes    |
| `enable_dns_support`   | `true`  | Enable/disable DNS support (`true` or `false`)                           |    No    |
| `enable_dns_hostnames` | `false` | Enable/disable DNS hostnames (`true` or `false`)                         |    No    |
| `public_subnets`       |         | Public subnets list `["10.0.0.0/24","10.0.1.0/24","10.0.2.0/24"]`        |    No    |
| `private_subnets`      |         | Private subnets list `["10.0.100.0/24","10.0.101.0/24","10.0.102.0/24"]` |    No    |
| `nat_gateway`          | `false` | NAT Gateway (`true` or `false`)                                          |    No    |

## Outputs

| Name                  | Description                                                                              |
| :-------------------- | :--------------------------------------------------------------------------------------- |
| `id`                  | VPC id (e.g. `vpc-678e4003`)                                                             |
| `public_subnet_ids`   | Public subnets id list (e.g. `["subnet-05fcd35c","subnet-0fedf878","subnet-13edda3e"]`)  |
| `private_subnet_ids`  | Private subnets id list (e.g. `["subnet-6a89d441","subnet-6bcef930","subnet-a645839b"]`) |
| `cidr`                | VPC CIDR block (e.g. `10.0.0.0/16`)                                                      |
| `default_sg_id`       | VPC Default security group (e.g. `sg-fd0bb786`)                                          |
| `public_route_table`  | Public route table id (Default route table) (e.g. `rtb-90298bef`)                        |
| `private_route_table` | Private route table id (e.g. `rtb-255bf95a`)                                             |
| `nat_gateway_id`      | NAT Gateway id (e.g. `nat-0da69aafcbaf2dc13`)                                            |
| `nat_gateway_ip`      | NAT Gateway public IP                                                                    |
