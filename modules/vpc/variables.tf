variable "vpc_cidr" {
  description = "CIDR block for the VPC"  
}

variable "env_name" {
  description = "Environment tag"  
}

variable "vpc_tag_name" {
  description = "VPC name tag"  
}

variable "cidr_pub_subnet" {
  description = "CIDR block for the public subnets"  
}

variable "availability_zones" {
  description = "Availability zones for subnet"  
}
