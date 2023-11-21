variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  #default = "10.0.0.0/16"
}

variable "env_name" {
  description = "Environment tag"
  #default = "dev"
}

variable "cidr_pub_subnet" {
  description = "CIDR block for the public subnets"
  #default = ["10.0.101.0/24", "10.0.102.0/24"]
}

# variable "az" {
#   description = "Availability zone for subnet"
#   default = ["us-east-1a", "us-east-1b"]
# }
