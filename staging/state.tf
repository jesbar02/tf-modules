terraform {
  backend "s3" {
    bucket  = "luna-staging-terraform-state"
    key     = "terraform-state"
    region  = "us-west-2"
    encrypt = true
  }
}
