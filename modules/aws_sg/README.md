# AWS Security Group

## Example 1

Requirements:

- `sg_ssh`: Security group with SSH access from source IP: `1.2.3.4/32`.
- `sg_http`: Security group with public HTTP/HTTPS access.

```hcl
module "vpc" {
  source      = "git::git@github.com:koombea/terraform_modules//aws_vpc"
  ...
}

module "sg_ssh" {
  source           = "git::git@github.com:koombea/terraform_modules//aws_sg"
  project          = "${var.project}"
  suffix_name      = "ssh"
  admin_source_ips = ["1.2.3.4/32"]
  vpc_id           = "${module.vpc.id}"
}

module "sg_http" {
  source       = "git::git@github.com:koombea/terraform_modules//aws_sg"
  project      = "${var.project}"
  suffix_name  = "http"
  public_ports = ["80","443"]
  vpc_id       = "${module.vpc.id}"
}
```

If you need to expose the 22 port to the world (Not recommended), set the `admin_source_ips` variable with the value `["0.0.0.0/0"]`.

## Example 2

Requirements:

- `sg_all_traffic`: Allow all network traffic from source IP `1.2.3.4/32`.

```hcl
module "vpc" {
  source      = "git::git@github.com:koombea/terraform_modules//aws_vpc"
  ...
}

module "sg_all_traffic" {
  source           = "git::git@github.com:koombea/terraform_modules//aws_sg"
  project          = "${var.project}"
  suffix_name      = "all-traffic"
  admin_proto      = "ALL"
  admin_port_from  = "0"
  admin_port_to    = "65535"
  admin_source_ips = ["1.2.3.4/32"]
  vpc_id           = "${module.vpc.id}"
}
```

## Example 4

The variables `admin_source_ips`, `admin_port_from`, `admin_port_to` and `admin_proto` by default allow SSH access on Linux instances by setting admin source IPs (`admin_source_ips`, See `sg_ssh` [Example 1](https://github.com/koombea/terraform_modules/tree/master/aws_sg#example-1)), but you can also use the module to allow adminitration access for non-Linux (¬¬) instances like Windows (TCP/3389):

- `sg_win`: Security group for Windows Server administration from `1.2.3.4/32` IP.

```hcl
module "vpc" {
  source      = "git::git@github.com:koombea/terraform_modules//aws_vpc"
  ...
}

module "sg_win" {
  source           = "git::git@github.com:koombea/terraform_modules//aws_sg"
  project          = "${var.project}"
  suffix_name      = "win-admin"
  admin_source_ips = ["1.2.3.4/32"]
  admin_port_from  = "3389"
  admin_port_to    = "3389"
  vpc_id           = "${module.vpc.id}"
}
```

## Variables

| Name                |        Default        | Description                                                             | Required |
| :------------------ | :-------------------: | :---------------------------------------------------------------------- | :------: |
| `create`            |         `true`        | Module optional execution (`true` or `false`)                           |    No    |
| `project`           |                       | Project (e.g. `flightlogger`, `saasler`)                                |   Yes    |
| `description`       | `Managed by @Koombea` | Security group description (e.g. `production`, `staging`)               |    No    |
| `suffix_name`       |                       | Suffix name for easy identification (e.g. `ssh`, `http`, `mysql`, `pg`) |   Yes    |
| `vpc_id`            |                       | VPC ID (e.g. `vpc-5616fe2c`)                                            |   Yes    |
| `admin_source_ips`  |         `[]`          | Source IPs list for server admin (e.g. `["1.2.3.4./32","4.3.2.1/32"]`)  |    No    |
| `admin_port_from`   |         `22`          | Admin port like SSH or RPD (e.g. `22`, `3389`)                          |    No    |
| `admin_port_to`     |         `22`          | Admin port (e.g. `22`, `3389`)                                          |    No    |
| `admin_proto`       |         `TCP`         | Admin Protocol (e.g. `TCP`, `ALL`)                                      |    No    |
| `public_ports`      |         `[]`          | Public port list (e.g. `["80","443"]`)                                  |    No    |
| `public_ports_from` |    `["0.0.0.0/0"]`    | By default `public_ports` are open from everywhere                      |    No    |
| `allow_own_traffic` |        `false`        | Allow own security group traffic? (e.g. `true` or `false`)              |    No    |

## Outputs

| Name | Description                            |
| :--- | :------------------------------------- |
| `id` | Security group id (e.g. `sg-fde0c080`) |
