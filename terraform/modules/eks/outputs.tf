output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = module.eks.cluster_name
}
output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

data "aws_eks_cluster_auth" "eks" {
  name = var.cluster_name
}

output "cluster_token" {
  value = data.aws_eks_cluster_auth.eks.token
}

output "cluster_certificate_authority_data" {
  value = module.eks.cluster_certificate_authority_data
  # aws_eks_cluster.this.certificate_authority[0].data
}


output "eks_oidc_issuer_url" {
  value = module.eks.cluster_oidc_issuer_url
  # aws_eks_cluster.this.identity[0].oidc[0].issuer
}


data "aws_security_group" "eks_default" {
  id = module.eks.cluster_security_group_id
  # id = tolist(data.aws_eks_cluster.this.vpc_config[0].security_group_ids)[0]
}

output "eks_default_sg" {
  value = module.eks.cluster_security_group_id
}
# output "eks_oidc_issuer_url" {
#   value = module.eks.eks_oidc_issuer_url
# }
