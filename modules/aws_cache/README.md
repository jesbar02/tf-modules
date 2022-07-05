# AWS ElastiCache

It will create by default a Redis(4.0) cluster.

## Usage

### Redis 4.0

- Customs parameters

```hcl
module "vpc" {
  source = "git::git@github.com:koombea/terraform_modules//aws_vpc"
  ...
}

module "redis" {
  source             = "git::git@github.com:koombea/terraform_modules//aws_cache"
  project            = "${var.project}"
  subnet_ids         = "${module.vpc.private_subnet_ids}"
  security_group_ids = ["${module.vpc.default_sg_id}"]

  parameters = [
    {
      name  = "activerehashing"
      value = "yes"
    },
  ]
}
```

### Redis 3.2

```hcl
module "vpc" {
  source = "git::git@github.com:koombea/terraform_modules//aws_vpc"
  ...
}

module "memcached" {
  source             = "git::git@github.com:koombea/terraform_modules//aws_cache"
  project            = "${var.project}"
  engine_family      = "redis3.2"
  subnet_ids         = "${module.vpc.private_subnet_ids}"
  security_group_ids = ["${module.vpc.default_sg_id}"]
}
```

### Memcached 1.4

```hcl
module "vpc" {
  source = "git::git@github.com:koombea/terraform_modules//aws_vpc"
  ...
}

module "memcached" {
  source             = "git::git@github.com:koombea/terraform_modules//aws_cache"
  project            = "${var.project}"
  engine_family      = "memcached1.4"
  subnet_ids         = "${module.vpc.private_subnet_ids}"
  security_group_ids = ["${module.vpc.default_sg_id}"]
}
```

## Variables

| Name                 |        Default        | Description                                              | Required |
| :------------------- | :-------------------: | :------------------------------------------------------- | :------: |
| `create`             |         `true`        | Module optional execution (`true` or `false`)            |    No    |
| `project`            |                       | Project (e.g. `flightlogger`, `saasler`)                 |   Yes    |
| `description`        | `Managed by @Koombea` | Resources description (e.g. `production`, `staging`)     |    No    |
| `engine_family`      |      `redis4.0`       | Engine family (`redis4.0`, `redis3.2` or `memcached1.4`) |    No    |
|  `parameters`        |         `[]`          | Instance parameters                                      |    No    |
| `node_type`          |   `cache.t2.micro`    | [Node type](https://aws.amazon.com/elasticache/pricing/) |    No    |
| `nodes`              |          `1`          | Number of replicas                                       |    No    |
| `security_group_ids` |                       | List of VPC security groups ids to associate             |   Yes    |
| `subnet_ids`         |                       | Litt of VPC Subnet ids                                   |   Yes    |
