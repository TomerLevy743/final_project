


# module "lb_role" {
#  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

#  role_name                              = "tomer_guy_eks_lb"
#  attach_load_balancer_controller_policy = true

#  oidc_providers = {
#      main = {
#      provider_arn               = var.oidc_arn
#      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
#      }
#  }
#  }


#  resource "kubernetes_service_account" "service-account" {
#  metadata {
#      name      = "aws-load-balancer-controller"
#      namespace = "kube-system"
#      labels = {
#      "app.kubernetes.io/name"      = "aws-load-balancer-controller"
#      "app.kubernetes.io/component" = "controller"
#      }
#      annotations = {
#      "eks.amazonaws.com/role-arn"               = module.lb_role.iam_role_arn
#      "eks.amazonaws.com/sts-regional-endpoints" = "true"
#      }
#  }
#  }

# IAM Role for ALB Controller
resource "aws_iam_role" "eks_alb_controller" {
  assume_role_policy = data.aws_iam_policy_document.alb_controller_assume_role_policy.json
  name               = "eks-alb-controller"
}

# Assume Role Policy Document for ALB Controller
data "aws_iam_policy_document" "alb_controller_assume_role_policy" {
  statement {
    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]
    effect = "Allow"
    condition {
      test     = "StringEquals"
      variable = "${var.eks_arn}:sub"
      values   = ["system:serviceaccount:kube-system:aws-load-balancer-controller"]
    }
    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::992382545251:oidc-provider/${var.eks_arn}"]
    }
  }
}

# IAM Policy for ALB Controller
resource "aws_iam_policy" "eks_alb_controller_policy" {
  name        = "eks-alb-controller-policy"
  description = "Policy for EKS ALB controller to manage ALB resources"

  policy = data.aws_iam_policy_document.alb_controller_policy.json
}

# Policy Document for ALB Controller
data "aws_iam_policy_document" "alb_controller_policy" {
  statement {
    actions = [
      "elasticloadbalancing:CreateLoadBalancer",
      "elasticloadbalancing:CreateTargetGroup",
      "elasticloadbalancing:CreateListener",
      "elasticloadbalancing:CreateRule",
      "elasticloadbalancing:ModifyLoadBalancerAttributes",
      "elasticloadbalancing:ModifyTargetGroup",
      "elasticloadbalancing:ModifyTargetGroupAttributes",
      "elasticloadbalancing:ModifyListener",
      "elasticloadbalancing:AddTags",
      "elasticloadbalancing:RemoveTags",
      "elasticloadbalancing:DeleteLoadBalancer",
      "elasticloadbalancing:DeleteTargetGroup",
      "elasticloadbalancing:DeleteListener",
      "elasticloadbalancing:DeleteRule",
      "elasticloadbalancing:RegisterTargets",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:SetIpAddressType",
      "elasticloadbalancing:SetSecurityGroups",
      "elasticloadbalancing:SetSubnets",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:CreateSecurityGroup",
      "ec2:DeleteSecurityGroup",
      "ec2:CreateTags",
      "ec2:DeleteTags",
      "ec2:ModifyInstanceAttribute",
      "ec2:ModifyNetworkInterfaceAttribute",
      "ec2:ModifySecurityGroupRules",
      "acm:DescribeCertificate",
      "acm:ListCertificates",
      "acm:GetCertificate",
      "ec2:DescribeAccountAttributes",
      "ec2:DescribeAddresses",
      "ec2:DescribeInternetGateways",
      "ec2:DescribeVpcs",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeInstances",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeTags",
      "ec2:GetCoipPoolUsage",
      "ec2:DescribeCoipPools",
      "ec2:DescribeAvailabilityZones",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeLoadBalancerAttributes",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:DescribeListenerCertificates",
      "elasticloadbalancing:DescribeSSLPolicies",
      "elasticloadbalancing:DescribeRules",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeTargetGroupAttributes",
      "elasticloadbalancing:DescribeTargetHealth",
      "elasticloadbalancing:DescribeTags",
      "elasticloadbalancing:DescribeListenerAttributes"
    ]
    resources = ["*"]
  }
}

# Attach the IAM Policy to the Role for ALB Controller
resource "aws_iam_role_policy_attachment" "eks_alb_controller" {
  role       = aws_iam_role.eks_alb_controller.name
  policy_arn = aws_iam_policy.eks_alb_controller_policy.arn
}

# Kubernetes Service Account for ALB Controller
resource "kubernetes_service_account" "alb_controller_service_account" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/name"      = "aws-load-balancer-controller"
      "app.kubernetes.io/component" = "controller"
    }
    annotations = {
      "eks.amazonaws.com/role-arn"               = aws_iam_role.eks_alb_controller.arn
      "eks.amazonaws.com/sts-regional-endpoints" = "true"
    }
  }
}



resource "helm_release" "alb-controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  depends_on = [
    kubernetes_service_account.alb_controller_service_account
  ]

  set {
    name  = "region"
    value = "us-east-1"
  }

  set {
    name  = "vpcId"
    value = var.vpc_id
  }

  set {
    name  = "image.repository"
    value = "602401143452.dkr.ecr.us-east-1.amazonaws.com/amazon/aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "clusterName"
    value = "tomer-guy-statuspage-cluster"
  }
}
