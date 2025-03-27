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
  eks_default_sg  = module.eks.eks_default_sg
}

module "eks" {
  source     = "./modules/eks"
  vpc_id     = module.vpc.vpc_id
  subnet_ids = concat(module.vpc.public_subnet_id, module.vpc.private_subnet_id)
  # adding the security groups to the eks cluster
  security_group_ids = [
    module.security_groups.frontend-sg,
    module.security_groups.backend-sg,
    module.security_groups.database-sg
  ]
  owner  = var.owner
  region = var.region
}

output "eks_oidc_issuer_url" {
  value = module.eks.eks_oidc_issuer_url
}

module "rds" {
  source      = "./modules/rds"
  subnet_ids  = module.vpc.private_subnet_id
  database-sg = module.security_groups.database-sg
  owner       = var.owner
}


output "rds_endpoint" {
  value = join("", regex("([^:]+)", module.rds.rds_endpoint))
}


module "status-page" {
  source       = "./modules/status-page-helm"
  rds_endpoint = module.rds.rds_endpoint
  depends_on   = [aws_eks_addon.csi_driver]
}
