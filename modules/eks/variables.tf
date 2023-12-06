variable "cidr_pub_subnet" {
    description = "Public subnet CIDR's"
}

variable "vpc_id" {
    description = "VPC ID"
}

variable "cluster_name" {
    description = "Cluster name"
}

variable "endpoint_private_access" {
    description = "EKS Endpoint private access status"
}

variable "endpoint_public_access" {
    description = "EKS Endpoint public access status"
}

variable "public_access_cidrs" {
    description = "CIDR's for EKS public access"
}

variable "node_group_name" {
    description = "Node group name"
}

variable "scaling_desired_size" {
    description = "Node group scaling "
}

variable "scaling_max_size" {
    description = "Scaling max size"
}

variable "scaling_min_size" {
    description = "Scaling min size"
}

variable "instance_types" {
    description = "Node group instance type"
}

variable "key_pair" {
    description = "Node instance key-pair"
}

variable "security_group_id" {
    description = "EKS cluster security group"
}

variable "env_name" {
    description = "Environment tag"
}

variable "cluster_role_arn" {
    description = "Cluster role ARN"
}

variable "node_group_role_arn" {
    description = "Node group role ARN"
}