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

variable "env_name" {
  description = "Environment tag"
 # default = "dev"
}