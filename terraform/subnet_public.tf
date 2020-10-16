## Public subnets, one for each AZ:
resource "aws_subnet" "public" {
  count  = data.terraform_remote_state._42.outputs.azcount
  vpc_id = aws_vpc.vpc.id
  cidr_block = element(data.terraform_remote_state._42.outputs.public_subnet_cidr,count.index)
  map_public_ip_on_launch = false
  availability_zone = element(data.terraform_remote_state._42.outputs.azs, count.index)
  tags = merge(var.tags, {
    Name           = "${terraform.workspace}-vpc-public-${element(data.terraform_remote_state._42.outputs.azs, count.index)}"
    environment    = terraform.workspace
  },)
}
output "public_subnet_id" { value = aws_subnet.public.*.id }


resource "aws_route_table_association" "public_rta" {
  count          = data.terraform_remote_state._42.outputs.azcount
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.igw_rt.id
}


