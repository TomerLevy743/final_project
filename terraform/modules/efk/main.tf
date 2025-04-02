
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
          "${var.eks_arn}:sub" = "system:serviceaccount:kube-system:fluentbit"
        }
      }
    }]
  })
}


resource "aws_iam_policy" "fluentbit_opensearch_policy" {
  name        = "FluentBitOpenSearchAccess"
  description = "IAM policy for Fluent Bit to push logs to CloudWatch"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
      ]
      Resource = "arn:aws:logs:${var.region}:992382545251:log-group:/aws/eks/${var.cluster_name}/fluentbit:*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "fluentbit_opensearch_attach" {
  role       = aws_iam_role.fluentbit_role.name
  policy_arn = aws_iam_policy.fluentbit_opensearch_policy.arn
}

resource "kubernetes_service_account" "fluentbit_sa" {
  metadata {
    name      = "fluentbit"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.fluentbit_role.arn
    }
  }
}


resource "helm_release" "aws_fluentbit" {
  name       = "aws-fluent-bit"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-for-fluent-bit"
  namespace  = "kube-system"

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.fluentbit_sa.metadata[0].name
  }

  set {
    name  = "cloudWatchLogs.enabled"
    value = "true"
  }

  set {
    name  = "cloudWatchLogs.logGroupName"
    value = "/aws/eks/${var.cluster_name}/fluentbit"
  }

  set {
    name  = "cloudWatchLogs.logStreamPrefix"
    value = "eks-logs/"
  }

  set {
    name  = "cloudWatchLogs.region"
    value = var.region
  }
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
