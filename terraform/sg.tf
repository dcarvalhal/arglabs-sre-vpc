# Allow all - for test purpose only
resource "aws_security_group" "sg_allow_all" {
  name        = "${terraform.workspace}-vpc-allow-all"
  description = "Allow ALL traffic"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(var.tags, {
    Name           = "${terraform.workspace}-vpc-allow-all"
    environment    = terraform.workspace
  },)
}
output "sg_allow_all_id" { value = aws_security_group.sg_allow_all.id }

# Allow OUTBOUND 
resource "aws_security_group" "sg_allow_out" {
  name        = "${terraform.workspace}-vpc-allow-out"
  description = "Allow ALL outbound traffic"
  vpc_id      = aws_vpc.vpc.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(var.tags, {
    Name           = "${terraform.workspace}-vpc-allow-out"
    environment    = terraform.workspace
  },)
}
output "sg_allow_out_id" { value = aws_security_group.sg_allow_out.id }

# Allow INBOUND - do not use!
resource "aws_security_group" "sg_allow_in" {
  name        = "${terraform.workspace}-vpc-allow-in"
  description = "Allow ALL inbound traffic"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(var.tags, {
    Name           = "${terraform.workspace}-vpc-allow-in"
    environment    = terraform.workspace
  },)
}
output "sg_allow_in_id" { value = aws_security_group.sg_allow_in.id }

# Allow COMMON
resource "aws_security_group" "sg_allow_common" {
  name        = "${terraform.workspace}-vpc-allow-common"
  description = "Allow common traffic"
  vpc_id      = aws_vpc.vpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["192.168.0.0/24", "10.0.0.0/16" ]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(var.tags, {
    Name           = "${terraform.workspace}-vpc-allow-common"
    environment    = terraform.workspace
  },)
}
output "sg_allow_common_id" { value = aws_security_group.sg_allow_common.id }

