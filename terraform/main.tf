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
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.31"

  cluster_name    = "tomer-guy-statuspage-cluster"
  cluster_version = "1.31"

  # Optional
  cluster_endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  cluster_compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnet_id + module.vpc.private_subnet_id

  tags = {
    Environment = "dev"
    Terraform   = "true"
    Owner       = var.owner
  }
}
