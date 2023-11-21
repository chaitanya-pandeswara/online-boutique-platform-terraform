output "cluster_role_arn_output" {
        value = aws_iam_role.eks_cluster_role.arn
}

output "node_group_role_arn_output" {
        value = aws_iam_role.eks_node_group_role.arn
}