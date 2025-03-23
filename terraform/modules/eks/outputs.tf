output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.this.name
}
output "cluster_endpoint" {
  value = aws_eks_cluster.this.endpoint
}

data "aws_eks_cluster_auth" "eks" {
  name = var.cluster_name
}

output "cluster_token" {
  value = data.aws_eks_cluster_auth.eks.token
}

output "cluster_certificate_authority_data" {
  value = aws_eks_cluster.this.certificate_authority[0].data
}
