# Configuring IGW for default route table
resource "aws_default_route_table" "terra_rtb" {
  default_route_table_id = var.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.gateway_id
  }

  tags = {
    Name = var.rtb_tag_name
    env = var.env_name
  }
}

# Associating Public Subnets with RouteTable
resource "aws_route_table_association" "terra_rtb_a" {
  count = length(var.subnet_ids)
  subnet_id = element(var.subnet_ids, count.index)
  route_table_id = aws_default_route_table.terra_rtb.id
}