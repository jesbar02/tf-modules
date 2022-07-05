# AWS ACM

It only supports DNS validation.

## Usage

Creating a wildcard certificate:

```hcl
module "acm" {
  source            = "git::git@github.com:koombea/terraform_modules//aws_acm"
  project           = "${var.project}"
  domain_name       = "example.com"
  alternative_names = ["*.example.com"]
  route53           = true
}
```

You can use `route53` flag for auto validation If `example.com` hosted zone exists at AWS Route53.

## Variables

| Name               | Default | Description                                    | Required |
| :----------------- | :-----: | :--------------------------------------------- | :------: |
| `create`           |  `true` | Module optional execution (`true` or `false`)  |    No    |
| `project`          |         | Project (e.g. `flightlogger`, `saasler`)       |   Yes    |
| `domain_name`      |         | Domain to be validated (e.g. `example.com`)    |   Yes    |
| `alternative_name` |  `[]`   | Additional domain names (e.g. `*.example.com`) |    No    |
| `route53`          | `false` | Route53 validation (`true`or `false`)          |    No    |

## Outputs

| Name          | Description                                    |
| :------------ | :--------------------------------------------- |
| `arn`         | ARN Certificate                                |
| `validations` | CNAME DNS Entries to validate domain ownership |
