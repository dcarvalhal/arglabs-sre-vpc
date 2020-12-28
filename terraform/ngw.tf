# The NAT gateways
resource "aws_nat_gateway" "ngw" {
  count         = data.terraform_remote_state._42.outputs.azcount
  allocation_id = element(aws_eip.ngw_eip.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  tags = merge(var.tags, {
    Name           = "${terraform.workspace}-vpc-ngw-${element(data.terraform_remote_state._42.outputs.azs, count.index)}"
    environment    = terraform.workspace
  },)
}
output "ngw_id" { value = aws_nat_gateway.ngw.*.id }

# Elastic IPs:
resource "aws_eip" "ngw_eip" {
  count = data.terraform_remote_state._42.outputs.azcount
  vpc   = true
  tags = merge(var.tags, {
    Name           = "${terraform.workspace}-vpc-ngw-eip-${element(data.terraform_remote_state._42.outputs.azs, count.index)}"
    environment    = terraform.workspace
  },)
}

output "ngw_eip_public_ip" { value = aws_eip.ngw_eip.*.public_ip }



# Route table to nat gateways
resource "aws_route_table" "ngw_rt" {
  count  = data.terraform_remote_state._42.outputs.azcount
  vpc_id = aws_vpc.vpc.id
  tags = merge(var.tags, {
    Name           = "${terraform.workspace}-vpc-ngw-rt-${element(data.terraform_remote_state._42.outputs.azs, count.index)}"
    environment    = terraform.workspace
  },)
}
output "ngw_rt_id" { value = aws_route_table.ngw_rt.*.id }

# Default route:
resource "aws_route" "default_route" {
  count = data.terraform_remote_state._42.outputs.azcount
  destination_cidr_block = "0.0.0.0/0"
  route_table_id = element(aws_route_table.ngw_rt.*.id, count.index)
  nat_gateway_id = element(aws_nat_gateway.ngw.*.id, count.index)
}


# iroute to to tgw:
resource "aws_route" "arglabs_cidr_route_tgw" {
  count = data.terraform_remote_state._42.outputs.azcount 
  route_table_id = element(aws_route_table.ngw_rt.*.id, count.index)
  destination_cidr_block = data.terraform_remote_state._42.outputs.arglabs_cidr
  transit_gateway_id = data.terraform_remote_state.tgw.outputs[data.terraform_remote_state._42.outputs.region] 
}

#resource "aws_route" "arglabs_cidr_route_other" {
#  count = terraform.workspace != "global" ? data.terraform_remote_state._42.outputs.azcount : 0
#  route_table_id = element(aws_route_table.ngw_rt.*.id, count.index)
#  destination_cidr_block = data.terraform_remote_state._42.outputs.arglabs_cidr
#  transit_gateway_id = data.terraform_remote_state.global_vpc.outputs.tgw_id
#}
