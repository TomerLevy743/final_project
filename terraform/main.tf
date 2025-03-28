module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  owner              = var.owner
}

module "eks" {
  source     = "./modules/eks"
  vpc_id     = module.vpc.vpc_id
  subnet_ids = concat(module.vpc.public_subnet_id, module.vpc.private_subnet_id)
  # adding the security groups to the eks cluster
  owner  = var.owner
  region = var.region
}
module "security_groups" {
  source         = "./modules/security_group"
  vpc_id         = module.vpc.vpc_id
  owner          = var.owner
  from_port      = var.from_port
  to_port        = var.to_port
  eks_default_sg = module.eks.eks_default_sg
}

module "node_group" {
  source       = "./modules/node_group"
  cluster_name = module.eks.cluster_name
  subnet_ids   = concat(module.vpc.public_subnet_id, module.vpc.private_subnet_id)
  owner        = var.owner
}

module "ebs" {
  source       = "./modules/ebs"
  cluster_name = module.eks.cluster_name
  eks_url      = module.eks.eks_oidc_issuer_url
  eks_nodes_up = module.node_group.cluster_nodes_up
}
module "rds" {
  source      = "./modules/rds"
  subnet_ids  = module.vpc.private_subnet_id
  database-sg = module.security_groups.database-sg
  owner       = var.owner
}

# module "alb" {
#   source      = "./modules/alb"
#   oidc_arn    = module.rds.oidc_arn
#   vpc_id      = module.vpc.vpc_id
# }


module "status-page" {
  source       = "./modules/status-page-helm"
  rds_endpoint = module.rds.rds_endpoint
}

