# Examples

Every example comes with the neccesary configuration for two environments: `staging` and `production`. Assign one of those values to the `$ENVIRONMENT` variable.

## Usage

Select one example, for instance: `docs/basic`. From that folder:

```sh
export ENVIRONMENT=staging # or production
terraform workspace new $ENVIRONMENT # or "select" if the workspace already exists
terraform init
terraform apply -var-file=config/$ENVIRONMENT.tfvars
```

## Cleaning resources

```sh
export ENVIRONMENT=staging # or production
terraform workspace select $ENVIRONMENT
terraform destroy -var-file=config/$ENVIRONMENT.tfvars
terraform workspace select default
terraform workspace delete $ENVIRONMENT
```
