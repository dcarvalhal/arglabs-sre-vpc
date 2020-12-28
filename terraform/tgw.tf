## Global vpc attachment
resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attach" {
  subnet_ids         = aws_subnet.public.*.id
  transit_gateway_id = data.terraform_remote_state.tgw.outputs[data.terraform_remote_state._42.outputs.region]
  vpc_id             = aws_vpc.vpc.id
  tags = merge(var.tags, {
    Name           = "${terraform.workspace}-vpc-tgw-attachment"
    environment    = terraform.workspace
  },)
}

