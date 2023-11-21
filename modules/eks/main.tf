# Creating EKS cluster
resource "aws_eks_cluster" "terra_eks" {
  name     = var.cluster_name
  role_arn = var.cluster_role_arn

  vpc_config {
    subnet_ids              = var.cidr_pub_subnet
    endpoint_public_access  = var.endpoint_public_access
    endpoint_private_access = var.endpoint_private_access
    public_access_cidrs     = var.public_access_cidrs
    security_group_ids      = [var.security_group_id]
  }

#   depends_on = [
#     aws_iam_role_policy_attachment.policy_AmazonEKSClusterPolicy,
#     aws_iam_role_policy_attachment.policy_AmazonEKSVPCResourceController,
#   ]

  tags = {
    env = var.env_name
  }
}

# Creating EKS Node Group
resource "aws_eks_node_group" "terra_eks_node" {
  cluster_name    = var.cluster_name
  node_group_name = var.node_group_name
  node_role_arn   = var.node_group_role_arn
  subnet_ids      = var.cidr_pub_subnet
  instance_types  = var.instance_types

  remote_access {
    source_security_group_ids = [var.security_group_id]
    ec2_ssh_key               = var.key_pair
  }

  scaling_config {
    desired_size = var.scaling_desired_size
    max_size     = var.scaling_max_size
    min_size     = var.scaling_min_size
  }

    depends_on = [aws_eks_cluster.terra_eks]

#   depends_on = [
#     aws_iam_role_policy_attachment.policy_AmazonEKSWorkerNodePolicy,
#     aws_iam_role_policy_attachment.policy_AmazonEKS_CNI_Policy,
#     aws_iam_role_policy_attachment.policy_AmazonEC2ContainerRegistryReadOnly,
#   ]
}