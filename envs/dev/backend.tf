terraform {
  backend "s3" {
    bucket  = "my-bucket"
    key     = "envs/dev/terraform.tfstate"
    region  = "eu-central-1"
    encrypt = true
  }
}
