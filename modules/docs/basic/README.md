# Basic

Basic example for VPC managments, it defines `staging` and `production` environments:

## Staging (config/staging.tfvars)

- CDIR Block: `10.1.0.0/16`
- Two public subnets: `10.1.0.0/24` and `10.1.1.0/24`
- Two private subnets: `10.1.100.0/24` and `10.1.101.0/24`

## Production (config/production.tfvars)

- CDIR Block: `10.0.0.0/16`
- Three public subnets: `10.0.0.0/24`, `10.0.1.0/24` and `10.0.2.0/24`
- Three private subnets: `10.0.100.0/24`, `10.0.101.0/24`, `10.0.102.0/24`
- NAT Gateway

Note: If you want to test with another environment, just create a new terraform workspace and a `config/` tfvars file.
