# IAM Policy
resource "aws_iam_policy" "tomer-guy-alb_ingress_controller_policy" {
  name        = "tomer-guy-ALBIngressControllerPolicy"
  description = "IAM policy for the ALB Ingress Controller"
  policy      = data.aws_iam_policy_document.tomer-guy-alb_ingress_controller_policy.json
}

data "aws_iam_policy_document" "tomer-guy-alb_ingress_controller_policy" {
  statement {
    actions   = ["elasticloadbalancing:CreateListener", "elasticloadbalancing:CreateLoadBalancer", "elasticloadbalancing:DescribeLoadBalancers", "elasticloadbalancing:DescribeListeners", "elasticloadbalancing:DescribeTargetGroups", "elasticloadbalancing:RegisterTargets", "elasticloadbalancing:DeregisterTargets"]
    resources = ["*"]
  }

  statement {
    actions   = ["ec2:DescribeSecurityGroups", "ec2:DescribeInstances", "ec2:DescribeSubnets", "ec2:DescribeVpcs", "ec2:CreateSecurityGroup", "ec2:AuthorizeSecurityGroupIngress", "ec2:RevokeSecurityGroupIngress"]
    resources = ["*"]
  }

  statement {
    actions   = ["iam:PassRole"]
    resources = [aws_iam_role.tomer-guy-alb_ingress_controller_role.arn]
  }
}

# IAM Role
resource "aws_iam_role" "tomer-guy-alb_ingress_controller_role" {
  name = "tomer-guy-ALBIngressControllerRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "eks.amazonaws.com" }
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "tomer-guy-alb_ingress_controller_attachment" {
  role       = aws_iam_role.tomer-guy-alb_ingress_controller_role.name
  policy_arn = aws_iam_policy.tomer-guy-alb_ingress_controller_policy.arn
}

# ALB Deploy
resource "helm_release" "tomer-guy-alb_ingress_controller" {
  name       = "tomer-guy-aws-alb-ingress-controller"
  namespace  = "kube-system"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.12.0"

  set {
    name  = "ingressController.enabled"
    value = "true"
  }

  set {
    name  = "ingressController.ingressClass"
    value = "alb"
  }

  set {
    name  = "ingressController.region"
    value = "us-east-1"
  }

  set {
    name  = "ingressController.clusterName"
    value = "tomer-guy-statuspage-cluster"  # Or use a variable like var.cluster_name
  }

  set {
    name  = "ingressController.awsVpcID"
    value = var.vpc_id  # Reference the VPC ID variable
  }

  set {
    name  = "ingressController.rbac.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.tomer-guy-alb_ingress_controller_role.arn  # Update with correct IAM role ARN
  }

  depends_on = [
    aws_iam_role_policy_attachment.tomer-guy-alb_ingress_controller_attachment
  ]
}