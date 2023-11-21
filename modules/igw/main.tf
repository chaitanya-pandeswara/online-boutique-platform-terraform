# Creating IGW
resource "aws_internet_gateway" "terra_igw" {
  vpc_id = var.vpc_id

  tags = {
    Name = "terra-igw"
    env = var.env_name
  }
}