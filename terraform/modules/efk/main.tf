










resource "aws_iam_role" "fluentbit_role" {
  name = "fluentbit-opensearch-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Federated = "arn:aws:iam::992382545251:oidc-provider/${var.eks_arn}"
      }
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "${var.eks_arn}:sub" = "system:serviceaccount:default:fluentbit"
        }
      }
    }]
  })
}

resource "aws_iam_policy" "fluentbit_opensearch_policy" {
  name        = "FluentBitOpenSearchAccess"
  description = "Allows Fluent Bit to write logs to OpenSearch"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = [
        "es:ESHttpPost",
        "es:ESHttpPut",
        "es:ESHttpGet",
        "es:ESHttpDelete",
        "es:ESHttpHead"
      ]
      Resource = "arn:aws:es:${var.region}:992382545251:domain/opensearch-tomer-guy/*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "fluentbit_opensearch_attach" {
  role       = aws_iam_role.fluentbit_role.name
  policy_arn = aws_iam_policy.fluentbit_opensearch_policy.arn
}




resource "helm_release" "fluentbit" {
  name       = "fluent-bit"
  repository = "https://fluent.github.io/helm-charts"
  chart      = "fluent-bit"

  values = [
    file("../k8s-manifests/minikube-test/helm/monitoring-chart/fluent-bit-config.yaml")
  ]
}


# Elasticsearch Installation
# resource "helm_release" "elasticsearch" {
#   name       = "elasticsearch"
#   namespace  = "default"

#   repository = "https://helm.elastic.co"
#   chart      = "elasticsearch"

#   values = [<<EOF
# replicas: 1
# minimumMasterNodes: 1
# resources:
#   requests:
#     memory: "1Gi"
#     cpu: "500m"
#   limits:
#     memory: "2Gi"
#     cpu: "1"
# secret:
#   enabled: true
#   password: "admin123"

# esConfig:
#   elasticsearch.yml: |
#     xpack.security.enabled: false
#     xpack.monitoring.templates.enabled: true
#   elasticsearch.ssl.verificationMode: "none"
# EOF
#   ]
# }
