# Identification:
variable "tags" {
  default = {
    terraform      = "true"
    team           = "infra"
    squad          = "sre"
    project        = "env-vpc"
    repository     = "git@github.com:ARGLabs/arglabs-sre-env-vpc.git" # git config --get remote.origin.url
  }
}
