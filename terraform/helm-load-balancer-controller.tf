# module "aws_load_balancer_controller_irsa_role" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
#   version = "5.3.1"

#   role_name = "guy-tomer-aws-load-balancer-controller"

#   attach_load_balancer_controller_policy = true

#   oidc_providers = {
#     ex = {
#       provider_arn               = aws_iam_openid_connect_provider.eks.arn
#       namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
#     }
#   }
# }


# resource "helm_release" "aws_load_balancer_controller" {
#   name = "aws-load-balancer-controller"

#   repository = "https://aws.github.io/eks-charts"
#   chart      = "aws-load-balancer-controller"
#   namespace  = "kube-system"
#   version    = "1.4.4"

#   set {
#     name  = "replicaCount"
#     value = 1
#   }

#   set {
#     name  = "clusterName"
#     value = "tomer-guy-statuspage-cluster"
#   }

#   set {
#     name  = "vpcId"
#     value = module.vpc.vpc_id
#   }

#   set {
#     name  = "serviceAccount.name"
#     value = "aws-load-balancer-controller"
#   }

#   set {
#     name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
#     value = "arn:aws:iam::992382545251:role/tomer-guy-ALBIngressControllerRole"
#   }
# }




module "lb_role" {
 source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

 role_name                              = "tomer_guy_eks_lb"
 attach_load_balancer_controller_policy = true

 oidc_providers = {
     main = {
     provider_arn               = aws_iam_openid_connect_provider.eks.arn
     namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
     }
 }
 }


 resource "kubernetes_service_account" "service-account" {
 metadata {
     name      = "aws-load-balancer-controller"
     namespace = "kube-system"
     labels = {
     "app.kubernetes.io/name"      = "aws-load-balancer-controller"
     "app.kubernetes.io/component" = "controller"
     }
     annotations = {
     "eks.amazonaws.com/role-arn"               = module.lb_role.iam_role_arn
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
     kubernetes_service_account.service-account
 ]

 set {
     name  = "region"
     value = "us-east-1"
 }

 set {
     name  = "vpcId"
     value = module.vpc.vpc_id
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