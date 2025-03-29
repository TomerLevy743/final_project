variable "cluster_name" {
  description = "cluster name"
  type        = string
}
variable "eks_url" {
  description = "EKS URL"
  type        = string
}

variable "eks_nodes_up" {
  description = "EKS nodes up"
  type        = string
}
variable "eks_arn" {
  description = "EKS ARN"
  type        = string
}

variable "oidc_provider_arn" {
  description = "oidc arn"
  type = string
}

variable "region" {
  description = "region"
  type = string
}
