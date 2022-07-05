# AWS Bastion Host

It creates a bastion host(EC2 Ubuntu 18.04) in order to provide remote access for private VPC resources (e.g. RDS instances) and handle host config and user administration with ansible.

## Requirements

- Ansible >= 2.7.0

## Usage

```hcl
module "vpc" {
  source         = "git::git@github.com:koombea/terraform_modules//aws_vpc"
  ...
  cidr_block     = "10.0.0.0/16"
  public_subnets = ["10.0.0.0/24","10.0.1.0/24","10.0.2.0/24"]
  ...
}

module "bastion" {
  source           = "git::git@github.com:koombea/terraform_modules//aws_bastion"
  project          = "${var.project}"
  # AMI
  # Any other Ubuntu Server AMI should work
  # If no AMI is provided, the latest Ubuntu 18.04 LTS AMI will be selected
  ami              = "ami-09e1c6dd3bd60cf2e"
  key_name         = "${var.ec2_key}"
  ec2_admins       = ["admin1","admin2"]
  ec2_users        = ["user1","user1"]
  public_subnet_id = "${module.vpc.public_subnet_ids[0]}"
}
```

- `ec2_admins` and `ec2_users` should contain only valid Github usernames because SSH access is granted using public SSH keys for each user (e.g. https://github.com/admin1.keys).
- `ec2_admins`: User list with `sudo` access.
- `ec2_users`: Regular user list without `sudo` access.

### Ansible

The ansible command is generated dynamically as a Terraform output called `ansible` through bastion module:

```bash
terraform output -module=bastion ansible
ansible-playbook --user ubuntu -i 1.2.3.4, --extra-vars {"base_hostname":...,"admins":["admin1","admin2"],"users":["user1","user2"]} /Absolute/Path/To/ansible/playbook.yml
```

- `1.2.3.4` A Valid IPv4 which is the EC2 public IP address.
- `base_hostname` ansible variable is the contatenation for `${var.project}`, `${terraform.workspace}` and literal `bastion` Terraform values.
- The local reference `/Absolute/Path/To/ansible/playbook.yml` is also auto generated.

To execute Ansible, just use the command substitution feature in BASH/ZSH `$(command)`:

```bash
$(terraform output -module=bastion ansible) --list-tasks --list-hosts

playbook: /Absolute/Path/To/ansible/playbook.yml

  play #1 (all): all    TAGS: []
    pattern: ['all']
    hosts (1):
      1.2.3.4 # A Valid IPv4 which is the EC2 public IP address`
    tasks:
      base : Set hostname {{ base_hostname }}   TAGS: [base, bastion, hostname]
      base : Fix /etc/hosts file        TAGS: [base, bastion, hostname]
      base : Upgrading software TAGS: [base, bastion, upgrade]
      base : Installing essentials      TAGS: [base, bastion]
      base : SSH daemon config  TAGS: [base, bastion, ssh]
      base : Reboot bastion host        TAGS: [base, bastion, reboot]
      admins : Creating admins {{ admins }}     TAGS: [admins, bastion]
      admins : Adding Github keys for admins {{ admins }}       TAGS: [admins, bastion]
      admins : sudo config for admins {{ admins }}      TAGS: [admins, bastion]
      admins : Deleting admins {{ delete_admins }}      TAGS: [bastion, delete_admins]
      admins : Delete sudo config for admins {{ delete_admins }}        TAGS: [bastion, delete_admins]
      users : Creating users {{ users }}        TAGS: [bastion, users]
      users : Adding Github keys for users {{ users }}  TAGS: [bastion, users]
      users : Deleting users {{ delete_users }} TAGS: [bastion, delete_users]
```

As you can see, after the command substitution `$()` you can use additional [`ansible-playbook`](https://docs.ansible.com/ansible/2.4/ansible-playbook.html) options:

```bash
$(terraform output -module=saasler.bastion ansible) --tags=base --list-tasks --list-hosts

playbook: /Absolute/Path/To/ansible/playbook.yml

  play #1 (all): all    TAGS: []
    pattern: ['all']
    hosts (1):
      1.2.3.4 # A Valid IPv4 which is the EC2 public IP address`
    tasks:
      base : Set hostname {{ base_hostname }}   TAGS: [base, bastion, hostname]
      base : Fix /etc/hosts file        TAGS: [base, bastion, hostname]
      base : Upgrading software TAGS: [base, bastion, upgrade]
      base : Installing essentials      TAGS: [base, bastion]
      base : SSH daemon config  TAGS: [base, bastion, ssh]
      base : Reboot bastion host        TAGS: [base, bastion, reboot]
```

### Deleting bastion host admins/users

How to delete `admin2` and `user2` users from bastion host? For user deletion use the `delete_admins` and `delete_users` ansible variables.

Modify `ec2_admin` and `ec2_users` terraform variables:

```hcl
module "vpc" {
  source         = "git::git@github.com:koombea/terraform_modules//aws_vpc"
  ...
  cidr_block     = "10.0.0.0/16"
  public_subnets = ["10.0.0.0/24","10.0.1.0/24","10.0.2.0/24"]
  ...
}

module "bastion" {
  source           = "/Users/pablox/Documents/pablox/terraform/aws_bastion"
  project          = "${var.project}"
  # AMI
  # Any other Ubuntu Server AMI should work
  # If no AMI is provided, the latest Ubuntu 18.04 LTS AMI will be selected
  ami              = "ami-09e1c6dd3bd60cf2e"
  key_name         = "${var.ec2_key}"
  ec2_admins       = ["admin1"] # admin2 deleted
  ec2_users        = ["user1"]  # user2 deleted
  public_subnet_id = "${module.vpc.public_subnet_ids[0]}"
}
```

Run `terraform apply` in order to refresh `ansible` terraform output value. Finally execute `ansible-playbook` with `delete_admin` and `delete_user` ansible variables and `delete_admins` and `delete_users` ansible tags:

```bash
terraform apply
...
$(terraform output -module=saasler.bastion ansible) --tags=delete_admins --extra-vars "delete_users=['admin2']"
....
$(terraform output -module=saasler.bastion ansible) --tags=delete_users --extra-vars "delete_users=['user2']"
....
```

## Variables

| Name                  |        Default        | Description                                                                                                                                       | Required |
| :-------------------- | :-------------------: | :------------------------------------------------------------------------------------------------------------------------------------------------ | :------: |
| `create`              |        `true`         | Module optional execution (`true` or `false`)                                                                                                     |    No    |
| `project`             |                       | Project (e.g. `flightlogger`, `saasler`)                                                                                                          |   Yes    |
| `key_name`            |                       | [EC2 Key Pair name](https://console.aws.amazon.com/ec2/v2/home?region=us-east-1#KeyPairs:sort=keyName)                                            |   Yes    |
| `default_admin_user`  |       `ubuntu`        | The default administrative user provided by the AMI, any Debian based distro should work                                                          |    No    |
| `ec2_admins`          |         `[]`          | User list with sudo access. All of them must be valid Github usernames                                                                            |    No    |
| `ec2_users`           |         `[]`          | User list without sudo access. All of them must be valid Github usernames                                                                         |    No    |
| `elastic_ip`          |        `false`        | Use an [Elastic IP](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html) on bastion host? (`true` or `false`)       |    No    |
| `public_subnet_id`    |                       | The bastion host must reside in a public subnet                                                                                                   |   Yes    |
| `source_cidr_blocks`  |    `["0.0.0.0/0"]`    | IPv4 addresses allowed for SSH connecitons. Public (`0.0.0.0/0`) by default                                                                       |   Yes    |
| `ami`                 |                       | [EC2 AMI](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html). If no AMI is provided, the latest Ubuntu 18.04 LTS AMI will be selected |    No    |
| `instance_type`       |      `t3.micro`       | [EC2 instace type](https://aws.amazon.com/ec2/instance-types/)                                                                                    |    No    |
| `description`         | `Managed by @Koombea` | Sub-resources description                                                                                                                         |    No    |

## Outputs

| Name         | Description                                         |
| :----------- | :-------------------------------------------------- |
| `id`         | EC2 instance id (e.g. `i-02ba771c79de0b04d`)        |
| `ami`        | Current EC2 AMI (e.g. `ami-09e1c6dd3bd60cf2e`)      |
| `private_ip` | EC2 private IP (e.g. `10.0.0.3`)                    |
| `public_ip`  | EC2 public IP (e.g. `18.191.205.254`)               |
| `ansible`    | Ansible command to handle bastion host provisioning |
