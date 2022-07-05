# AWS RDS

It creates a PostgreSQL 10 by default and supports PostgreSQL 9.6, 10 and MySQL 5.6, 5.7.

## Usage

### PostgreSQL 10

- Private PostgreSQL 10 instance

```hcl
module "vpc" {
  source = "git::git@github.com:koombea/terraform_modules//aws_vpc"
  ...
}

module "postgres" {
  source             = "git::git@github.com:koombea/terraform_modules//aws_rds"
  project            = "${var.project}"
  password           = "MySuperSecretPassword"
  subnet_ids         = "${module.vpc.private_subnet_ids}"
  security_group_ids = ["${module.vpc.default_sg_id}"]
}
```

### PostgreSQL 9.6

- Private PostgreSQL 9.6 instance
- Custom log retention period to 1 day (`aws rds describe-db-parameters --db-parameter-group-name MY_PARAMETER_GROUP`)

```hcl
module "vpc" {
  source = "git::git@github.com:koombea/terraform_modules//aws_vpc"
  ...
}

module "postgres" {
  source             = "git::git@github.com:koombea/terraform_modules//aws_rds"
  project            = "${var.project}"
  engine_family      = "postgres9.6"
  password           = "MySuperSecretPassword"
  subnet_ids         = "${module.vpc.private_subnet_ids}"
  security_group_ids = ["${module.vpc.default_sg_id}"]

  parameters = [
    {
      name  = "rds.log_retention_period"
      value = "1440"
    },
  ]
}
```

### MySQL 5.6

- Public MySQL 5.6 instance

```hcl
module "vpc" {
  source               = "git::git@github.com:koombea/terraform_modules//aws_vpc"
  ...
  enable_dns_hostnames = true
  ...
}

module "mysql" {
  source              = "git::git@github.com:koombea/terraform_modules//aws_rds"
  project             = "${var.project}"
  engine_family       = "mysql5.6"
  password            = "MySuperSecretPassword"
  subnet_ids          = "${module.vpc.public_subnet_ids}"
  security_group_ids  = ["${module.vpc.default_sg_id}"]
  publicly_accessible = true
}
```

### MySQL 5.7

- Private MySQL 5.7 instance

```hcl
module "vpc" {
  source = "git::git@github.com:koombea/terraform_modules//aws_vpc"
  ...
}

module "mysql" {
  source             = "git::git@github.com:koombea/terraform_modules//aws_rds"
  project            = "${var.project}"
  engine_family      = "mysql5.7"
  password           = "MySuperSecretPassword"
  subnet_ids         = "${module.vpc.private_subnet_ids}"
  security_group_ids = ["${module.vpc.default_sg_id}"]
}
```

## Variables

| Name                    |        Default        | Description                                                                                 | Required |
| :---------------------- | :-------------------: | :------------------------------------------------------------------------------------------ | :------: |
| `create`                |         `true`        | Module optional execution (`true` or `false`)                                               |    No    |
| `project`               |                       | Project (e.g. `flightlogger`, `saasler`)                                                    |   Yes    |
| `password`              |                       | Master password                                                                             |   Yes    |
| `description`           | `Managed by @Koombea` | Resources description                                                                       |    No    |
| `engine_family`         |     `postgres10`      | Engine family (`postgres10`, `postgres9.6`, `mysql5.6` or `mysql5.7`)                       |    No    |
| `storage`               |         `20`          | Intance storage size (GB) (e.g. `25`, `50`, `100`)                                          |    No    |
| `instance_type`         |     `db.t2.micro`     | [Instance type](https://aws.amazon.com/rds/pricing/)                                        |    No    |
| `publicly_accessible`   |        `false`        | If `true` use public VPC subnets for `subnet_ids` and enable VPC `enable_dns_hostnames`     |    No    |
| `security_group_ids`    |                       | List of VPC security groups ids to associate                                                |   Yes    |
| `subnet_ids`            |                       | List of VPC Subnet ids                                                                      |   Yes    |
| `apply_immediately`     |        `true`         | Apply changes immediatly (after `terrafor apply`) or wait until the next maintenance window |    No    |
| `parameters`            |         `[]`          | Database parameters                                                                         |    No    |
| `maintenance_window`    | `Mon:13:00-Mon:16:00` | Maintenance window (UTC)                                                                    |    No    |
| `backup_retention_days` |          `7`          | Number of days for backup retention                                                         |    No    |
| `backup_window`         |     `05:00-06:00`     | Backup window (UTC)                                                                         |    No    |

## Outputs

| Name                 | Description                                                                             |
| :------------------- | :-------------------------------------------------------------------------------------- |
| `address`            | RDS Address (e.g. `example-staging.cuyjcgbsaegn.us-east-1.rds.amazonaws.com`)           |
| `endpoint`           | `address`:`port` (e.g. `example-staging.cuyjcgbsaegn.us-east-1.rds.amazonaws.com:3306`) |
| `subnet_group_id`    | RDS Subnet group name (e.g. `example-staging-postgres10`)                               |
| `parameter_group_id` | RDS Parameter group name (e.g. `example-staging-mysql5.7`)                              |
