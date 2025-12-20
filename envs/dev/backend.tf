terraform {
  backend "s3" {
    bucket  = "yavornikolaev90-terraform-state-dev"
    key     = "envs/dev/terraform.tfstate"
    region  = "eu-central-1"
    encrypt = true
  }
}