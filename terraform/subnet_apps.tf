## Public subnets, one for each AZ:
resource "aws_subnet" "apps" {
  count  = terraform.workspace != "global" ? data.terraform_remote_state._42.outputs.azcount : 0
  vpc_id = aws_vpc.vpc.id
  cidr_block = element(data.terraform_remote_state._42.outputs.apps_subnet_cidr,count.index)
  map_public_ip_on_launch = false
  availability_zone = element(data.terraform_remote_state._42.outputs.azs, count.index)
  tags = merge(var.tags, {
    Name           = "${terraform.workspace}-vpc-apps-${element(data.terraform_remote_state._42.outputs.azs, count.index)}"
    environment    = terraform.workspace
  },)
}
output "apps_subnet_id" { value = aws_subnet.apps.*.id }


resource "aws_route_table_association" "apps_rta" {
  count  = terraform.workspace != "global" ? data.terraform_remote_state._42.outputs.azcount : 0
  subnet_id      = element(aws_subnet.apps.*.id, count.index)
  route_table_id = element(aws_route_table.ngw_rt.*.id, count.index)

}


