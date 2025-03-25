data "tls_certificate" "eks" {
  url = module.eks.eks_oidc_issuer_url
}

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = module.eks.eks_oidc_issuer_url
  depends_on      = [data.tls_certificate.eks]
}

data "aws_iam_openid_connect_provider" "eks" {
  url = module.eks.eks_oidc_issuer_url
  depends_on = [data.tls_certificate.eks,
    aws_iam_openid_connect_provider.eks
  ]
}

output "oidc_arn" {
  value = data.aws_iam_openid_connect_provider.eks.arn
}

output "oidc_id" {
  value = data.aws_iam_openid_connect_provider.eks.id
}
