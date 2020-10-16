## Public subnets, one for each AZ:
resource "aws_subnet" "build" {
  count = terraform.workspace == "global" ? data.terraform_remote_state._42.outputs.azcount : 0
  vpc_id = aws_vpc.vpc.id
  cidr_block = element(data.terraform_remote_state._42.outputs.build_subnet_cidr,count.index)
  map_public_ip_on_launch = false
  availability_zone = element(data.terraform_remote_state._42.outputs.azs, count.index)
  tags = merge(var.tags, {
    Name           = "${terraform.workspace}-vpc-build-${element(data.terraform_remote_state._42.outputs.azs, count.index)}"
    environment    = terraform.workspace
  },)
}
output "build_subnet_id" { value = aws_subnet.build.*.id }


resource "aws_route_table_association" "build_rta" {
  count = terraform.workspace == "global" ? data.terraform_remote_state._42.outputs.azcount : 0
  subnet_id      = element(aws_subnet.build.*.id, count.index)
  route_table_id = aws_route_table.igw_rt.id
}


