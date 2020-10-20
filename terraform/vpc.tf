# VPC Infra e IG
resource "aws_vpc" "vpc" {
  cidr_block           = data.terraform_remote_state._42.outputs.env_cidr 
  enable_dns_hostnames = true
  tags = merge(var.tags, {
    Name           = "${terraform.workspace}-vpc"
    environment    = terraform.workspace
  },)
}
output "vpc_id"         { value = aws_vpc.vpc.id }
output "vpc_cidr_block" { value = aws_vpc.vpc.cidr_block }


# DHCP options set:
resource "aws_vpc_dhcp_options" "vpc_dhcp_options" {
  domain_name_servers = [ "AmazonProvidedDNS" ]
  domain_name         = "arglabs"
}
resource "aws_vpc_dhcp_options_association" "vpc_dhcp_options_association" {
  vpc_id          = aws_vpc.vpc.id
  dhcp_options_id = aws_vpc_dhcp_options.vpc_dhcp_options.id
}

