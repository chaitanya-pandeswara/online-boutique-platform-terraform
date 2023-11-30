vpc_cidr = "10.0.0.0/16"
cidr_pub_subnet = ["10.0.101.0/24", "10.0.102.0/24"]
env_name = "dev"
cluster_name = "terra-eks-cluster"
endpoint_private_access = false
endpoint_public_access = true
public_access_cidrs = ["0.0.0.0/0"]
node_group_name = "terra-eks-node-group"
scaling_desired_size = 1
scaling_max_size = 2
scaling_min_size = 1
instance_types = ["t3a.medium"]
key_pair = "chaitu-aws-IN"
eks_cluster_role_name = "eksClusterRole"
eks_node_group_role_name = "eksNodeGroupRole"


