resource "helm_release" "alb_ingress_controller" {
  name       = "aws-alb-ingress-controller"
  namespace  = "kube-system"
  repository = "eks"
  chart      = "aws-load-balancer-controller"

  set {
    name  = "clusterName"
    value = var.cluster_name
  }
  set {
    name  = "serviceAccount.create"
    value = "true"
  }
  set {
    name  = "serviceAccount.name"
    value = "alb-ingress-controller"
  }
}

resource "aws_iam_role" "alb_ingress_controller_role" {
  name = "alb-ingress-controller-role"
  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17",
      Statement = [
        {
          Effect = "Allow",
          Principal = {
            Service = "eks.amazonaws.com"
          },
          Action = "sts:AssumeRole",
          Sid    = ""
        }
      ]
    }
  )
}

resource "aws_iam_policy" "alb_ingress_controller_policy" {
  name        = "alb-ingress-controller-policy"
  description = "Policy for ALB Ingress Controller"
  policy      = file("${path.module}/alb-ingress-controller-policy.json")
}

resource "aws_iam_role_policy_attachment" "alb_ingress_controller_policy_attachment" {
  role       = aws_iam_role.alb_ingress_controller_role.name
  policy_arn = aws_iam_policy.alb_ingress_controller_policy.arn
}
