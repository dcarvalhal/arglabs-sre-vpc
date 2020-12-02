# Identification:
variable "tags" {
  default = {
    terraform      = "true"
    team           = "infra"
    squad          = "sre"
    project        = "vpc"
    repository     = "git@github.com:ARGLabs/arglabs-sre-vpc.git" 
  }
}
variable "bucket" { }
variable "bucket_region" { }

