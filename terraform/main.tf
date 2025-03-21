module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  owner              = var.owner
}

module "security_groups" {
  source    = "./modules/security_group"
  vpc_id    = module.vpc.vpc_id
  owner     = var.owner
  from_port = var.from_port
  to_port   = var.to_port
}

module "eks" {
  source = "./modules/eks"
  # source  = "terraform-aws-modules/eks/aws"
  # version = "~> 20.31"
  # cluster_name = cluster_name
  # cluster_name    = "tomer-guy-statuspage-cluster"
  # cluster_version = "1.31"

  # Optional
  # cluster_endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  # enable_cluster_creator_admin_permissions = true
  # authentication_mode                      = "API_AND_CONFIG_MAP"
  # cluster_compute_config = {
  #   enabled    = true
  #   node_pools = ["general-purpose"]
  # }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = concat(module.vpc.public_subnet_id, module.vpc.private_subnet_id)
  # adding the security groups to the eks cluster
  security_group_ids = [
    module.security_groups.frontend-sg,
    module.security_groups.backend-sg,
    module.security_groups.database-sg
  ]
  # security_group_database = module.security_groups.database_security_group_id
  # security_group_frontend = module.security_groups.frontend_security_group_id
  # security_group_backend  = module.security_groups.backend_security_group_id

  # tags = {
  #   Environment = "dev"
  #   Terraform   = "true"
  #   Owner       = var.owner
  # }
  # eks_managed_node_groups = {
  #   example = {
  #     ami_type       = "AL2023_x86_64_NVIDIA"
  #     instance_types = ["p5.48xlarge"]


  #     cloudinit_pre_nodeadm = [
  #       {
  #         content_type = "application/node.eks.aws"
  #         content      = <<-EOT
  #           ---
  #           apiVersion: node.eks.aws/v1alpha1
  #           kind: NodeConfig
  #           spec:
  #             instance:
  #               localStorage:
  #                 strategy: RAID0
  #         EOT
  #       }
  #     ]

  #   }
  # }
}
