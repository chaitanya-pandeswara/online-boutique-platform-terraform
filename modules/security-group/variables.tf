variable "vpc_id" {
  description = "VPC ID"
}

# variable "inbound_cidr" {
#   description = "Inbound CIDR"
#  # default = "0.0.0.0/0"
# }

# variable "outbound_cidr" {
#   description = "Outbound CIDR"
#  # default = "0.0.0.0/0"
# }

variable "sg_name" {
  description = "SG name" 
}

variable "env_name" {
  description = "Environment tag" 
}

variable "sg_tag_name" {
  description = "SG name tag" 
}