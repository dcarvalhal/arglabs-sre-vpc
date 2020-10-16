## Public subnets, one for each AZ:
resource "aws_subnet" "services" {
  count  = data.terraform_remote_state._42.outputs.azcount
  vpc_id = aws_vpc.vpc.id
  cidr_block = element(data.terraform_remote_state._42.outputs.services_subnet_cidr,count.index)
  map_public_ip_on_launch = false
  availability_zone = element(data.terraform_remote_state._42.outputs.azs, count.index)
  tags = merge(var.tags, {
    Name           = "${terraform.workspace}-vpc-services-${element(data.terraform_remote_state._42.outputs.azs, count.index)}"
    environment    = terraform.workspace
  },)
}
output "services_subnet_id" { value = aws_subnet.services.*.id }


resource "aws_route_table_association" "services_rta" {
  count          = data.terraform_remote_state._42.outputs.azcount
  subnet_id      = element(aws_subnet.services.*.id, count.index)
  route_table_id = element(aws_route_table.ngw_rt.*.id, count.index)

}


