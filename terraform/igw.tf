resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(var.tags, {
    Name           = "${terraform.workspace}-igw"
    environment    = terraform.workspace
  },)
}
output "igw_id" { value = aws_internet_gateway.igw.id }



## Route table to IGW
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
