variable "vpc_cidr" {}

variable "cidr_pub_subnet" {
  type = list(any)
}

variable "env_name" {}

variable "cluster_name" {}

variable "node_group_name" {}

variable "endpoint_private_access" {}

variable "endpoint_public_access" {}

variable "public_access_cidrs" {}

variable "scaling_desired_size" {}

variable "scaling_max_size" {}

variable "scaling_min_size" {}

variable "instance_types" {}

variable "key_pair" {}

# variable "cluster_role_arn" {
#   description = "Cluster role arn" 
# }

# variable "node_group_role_arn" {
#   description = "Node Group role arn" 
# }

variable "eks_cluster_role_name" {
  description = "Cluster role name"  
}

variable "eks_node_group_role_name" {
  description = "Node Group role name"  
}
