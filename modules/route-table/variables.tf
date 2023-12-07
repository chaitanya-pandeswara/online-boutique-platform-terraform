variable "default_route_table_id" {
  description = "Default route table ID of the VPC"  
}

variable "env_name" {
  description = "Environment tag"  
}

variable "rtb_tag_name" {
  description = "RTB name tag"  
}

variable "subnet_ids" {
  description = "CIDR block for the public subnets"  
}

variable "gateway_id" {
  description = "IGW ID"  
}