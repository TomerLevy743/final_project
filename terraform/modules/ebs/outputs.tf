output "oidc_arn" {
  description = "The ARN of the OpenID Connect provider"
  value       = aws_iam_openid_connect_provider.eks.arn
}