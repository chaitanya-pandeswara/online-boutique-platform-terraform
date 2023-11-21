output "cluster_id" {
  description = "EKS cluster ID"
  value       = aws_eks_cluster.terra_eks.id
}