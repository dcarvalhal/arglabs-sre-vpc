# Terraform:
terraform { 
  required_version = ">= 0.13"
  required_providers {
    aws = { version = ">= 3.10.0" }
  }
  backend "s3" {
#    bucket    = ""
#    region    = ""
    key       = "infra/sre/vpc.state"
  }
}

# Deep thought definitions:
data "terraform_remote_state" "_42" {
  backend   = "s3"
  workspace = terraform.workspace
  config = {
    bucket = var.bucket
    region = var.bucket_region
    key    = "infra/sre/deep_thought.state"
  }
}


# Global VPC definitions:
data "terraform_remote_state" "global_vpc" {
  backend   = "s3"
  workspace = "global"
  config = {
    bucket = var.bucket
    region = var.bucket_region
    key    = "infra/sre/vpc.state"
  }
}

# TGW definitions:
data "terraform_remote_state" "tgw" {
  backend   = "s3"
  workspace = "default"
  config = {
    bucket = var.bucket
    region = var.bucket_region
    key    = "infra/sre/tgw.state"
  }
}


# AWS:
provider "aws"    { region = data.terraform_remote_state._42.outputs.region }
output   "region" { value  = data.terraform_remote_state._42.outputs.region }

