resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(var.tags, {
    Name           = "${terraform.workspace}-igw"
    environment    = terraform.workspace
  },)
}
output "igw_id" { value = aws_internet_gateway.igw.id }



## Route table to IGW only (used by public networks and build subnet)
resource "aws_route_table" "igw_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(var.tags, {
    Name           = "${terraform.workspace}-vpc-igw-rt"
    environment    = terraform.workspace
  },)
}
output "igw_rt_id" { value = aws_route_table.igw_rt.*.id }


## Route table to IGW and TGW (used by VPN)
resource "aws_route_table" "igw_tgw_rt" {
  count = terraform.workspace == "global" ? 1 : 0
  vpc_id = aws_vpc.vpc.id
  tags = merge(var.tags, {
    Name           = "${terraform.workspace}-vpc-igw-tgw-rt"
    environment    = terraform.workspace
  },)
}
output "igw_tgw_rt_id" { value = join("", aws_route_table.igw_tgw_rt.*.id) }


resource "aws_route" "igw_default_route" {
  count = terraform.workspace == "global" ? 1 : 0
  route_table_id = join("", aws_route_table.igw_tgw_rt.*.id)
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

#resource "aws_route" "igw_tgw_route" {
#  count = terraform.workspace == "global" ? 1 : 0
#  route_table_id = join("", aws_route_table.igw_tgw_rt.*.id)
#  destination_cidr_block = data.terraform_remote_state._42.outputs.arglabs_cidr
#  transit_gateway_id = join("", aws_ec2_transit_gateway.tgw.*.id)
#  depends_on = [
#    aws_ec2_transit_gateway.tgw,
#    aws_route_table.igw_tgw_rt,
#  ]
#}

