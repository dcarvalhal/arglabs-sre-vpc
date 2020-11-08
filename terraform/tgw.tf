resource "aws_ec2_transit_gateway"  "tgw" {
  # Create only on global workspace
  count = terraform.workspace     == "global" ? 1 : 0
  description                     = "${terraform.workspace}-tgw"
  amazon_side_asn                 = "64512"
  auto_accept_shared_attachments  = "enable"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  dns_support                     = "enable"
  tags = merge(var.tags, {
    Name           = "${terraform.workspace}-tgw"
    environment    = terraform.workspace
  },)
}

output "tgw_id"       { value = join("", aws_ec2_transit_gateway.tgw.*.id )}
output "tgw_owner_id" { value = aws_ec2_transit_gateway.tgw.*.owner_id }
output "tgw_propagation_default_route_table_id" { value = aws_ec2_transit_gateway.tgw.*.propagation_default_route_table_id }
output "tgw_association_default_route_table_id" { value = aws_ec2_transit_gateway.tgw.*.association_default_route_table_id }

## Global vpc attachment
resource "aws_ec2_transit_gateway_vpc_attachment" "global_vpc_tgw_attach" {
  count = terraform.workspace == "global" ? 1 : 0
  subnet_ids         = aws_subnet.public.*.id
  transit_gateway_id = aws_ec2_transit_gateway.tgw[count.index].id
  vpc_id             = aws_vpc.vpc.id
  tags = merge(var.tags, {
    Name           = "${terraform.workspace}-vpc-tgw-attachment"
    environment    = terraform.workspace
  },)
}
output "tgw_attach_id_global" { 
  value = aws_ec2_transit_gateway_vpc_attachment.global_vpc_tgw_attach.*.id 
}

## Other envs vpc attachment
resource "aws_ec2_transit_gateway_vpc_attachment" "vpc_tgw_attach_env" {
  count = terraform.workspace != "global" ? 1 : 0
  subnet_ids         = aws_subnet.public.*.id
  transit_gateway_id = data.terraform_remote_state.global_vpc.outputs.tgw_id
  vpc_id             = aws_vpc.vpc.id
  tags = merge(var.tags, {
    Name           = "${terraform.workspace}-vpc-tgw-attachment"
    environment    = terraform.workspace
  },)
}
output "tgw_attach_id_env"       { value = aws_ec2_transit_gateway_vpc_attachment.vpc_tgw_attach_env.*.id }

