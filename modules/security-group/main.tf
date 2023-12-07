# Creating Security Group for EKS cluster
resource "aws_security_group" "terra_sg" {
  name = var.sg_name
  description = "To provide access to Chaitanya."
  vpc_id = var.vpc_id
  
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "SSH access to Chaitanya"    
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "HTTP access to Chaitanya"    
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  tags = {
    Name = var.sg_tag_name
    env = var.env_name
  }

}