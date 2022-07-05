# AWS ECR

Creates a container registry using [Elastic Container Registry](https://docs.aws.amazon.com/AmazonECR/latest/userguide/what-is-ecr.html). By default will store `500` tagged images and store untagged image for 2 days.

## Usage

### Example 1

- Create a docker registry with:
  - Store 800 tagged images.
  - Delete untagged images after 8 days.

```hcl
module "ecr" {
  source             = "git::git@github.com:koombea/terraform_modules//aws_ecr"
  project            = "${var.project}"
  tagged_image_count = 800
  untagged_day_count = 8
}
```

## Variables

| Name                 |     Default     | Description                                                        | Required |
| :------------------- | :-------------: | :----------------------------------------------------------------- | :------: |
| `create`             |      `true`     | Module optional execution (`true` or `false`)                      |    No    |
| `project`            |                 | Project (e.g. `flightlogger`, `saasler`)                           |   Yes    |
| `tagged_image_count` |      `500`      | How many tagged docker images to store                             |    No    |
| `untagged_day_count` |       `2`       | Expire untagged images older than `untagged_day_count` days        |    No    |
| `tag_prefixes`       |  `["feature_"]` | List of image tag prefixes to take action on with lifecycle policy |    No    |

- `tag_prefixes` If docker images are tagged as "prod", "prod1", "prod2", etc you would use the tag prefix `prod` to specify all of them. If you specify multiple tags, only images with all specified tags will be selected.

## Outputs

| Name  | Description                                                                 |
| :---- | :-------------------------------------------------------------------------- |
| `arn` | Registry ARN                                                                |
| `url` | Registry URL (`aws_account_id.dkr.ecr.region.amazonaws.com/repositoryName`) |
