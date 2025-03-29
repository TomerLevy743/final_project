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
}


output "eks_oidc_issuer_url" {
  value = module.eks.cluster_oidc_issuer_url
}


data "aws_security_group" "eks_default" {
  id = module.eks.cluster_security_group_id
}

output "eks_default_sg" {
  value = module.eks.cluster_security_group_id
}
data "aws_caller_identity" "current" {}
output "oidc_provider_arn" {
  value = module.eks.oidc_provider
  # value = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/oidc.eks.${var.region}.amazonaws.com/id/${module.eks.cluster_arn}"
}
output "eks_id" {
  value = module.eks.oidc_provider_arn
}

output "cluster_security_group_id" {
  value = module.eks.cluster_security_group_id
}