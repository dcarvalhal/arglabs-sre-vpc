# Terraform:
terraform { 
  required_version = ">= 0.13"
  required_providers {
    aws = { version = ">= 3.10.0" }
  }
  backend "s3" {
    bucket    = "arglabs-terraform-states"
    region    = "sa-east-1"
    key       = "sre/env_vpc.state"
  }
}

# Global definitions:
data "terraform_remote_state" "_42" {
  backend   = "s3"
  workspace = terraform.workspace
  config = {
    bucket = "arglabs-terraform-states"
    region = "sa-east-1"
    key    = "deep_tought.state"
  }
}


# Global definitions:
data "terraform_remote_state" "global_vpc" {
  backend   = "s3"
  workspace = "global"
  config = {
    bucket = "arglabs-terraform-states"
    region = "sa-east-1"
    key    = "sre/env_vpc.state"
  }
}




# AWS:
provider "aws" { region = data.terraform_remote_state._42.outputs.region }

