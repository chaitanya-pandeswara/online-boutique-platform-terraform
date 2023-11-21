variable "env_name" {
  description = "Environment tag"
  #default = "dev"
}

variable "eks_cluster_role_name" {
  description = "Cluster role name"  
}

variable "eks_node_group_role_name" {
  description = "Node Group role name"  
}