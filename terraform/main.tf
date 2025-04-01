module "vpc" {
  source             = "./modules/vpc"
  naming             = var.naming
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  owner              = var.owner
}

module "eks" {
  source       = "./modules/eks"
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = concat(module.vpc.public_subnet_id, module.vpc.private_subnet_id)
  cluster_name = "${var.naming}statuspage-cluster"
  # adding the security groups to the eks cluster
  owner  = var.owner
  region = var.region
}
module "security_group" {
  source         = "./modules/security_group"
  vpc_id         = module.vpc.vpc_id
  owner          = var.owner
  from_port      = var.from_port
  to_port        = var.to_port
  eks_default_sg = module.eks.node_group_security_group_id
  naming         = var.naming
}

module "node_group" {
  source                          = "./modules/node_group"
  cluster_name                    = module.eks.cluster_name
  node_group_name                 = "${var.naming}ng"
  subnet_ids                      = concat(module.vpc.public_subnet_id, module.vpc.private_subnet_id)
  cluster_security_group_id       = module.eks.cluster_security_group_id
  cluster_nodes_security_group_id = module.eks.node_group_security_group_id
  owner                           = var.owner
}

module "ebs" {
  source            = "./modules/ebs"
  cluster_name      = module.eks.cluster_name
  eks_url           = module.eks.eks_oidc_issuer_url
  eks_arn           = module.eks.oidc_provider_arn
  eks_nodes_up      = module.node_group.cluster_nodes_up
  oidc_provider_arn = module.eks.oidc_provider_arn
  eks_id            = module.eks.eks_id
  region            = var.region
}
module "rds" {
  source      = "./modules/rds"
  subnet_ids  = module.vpc.private_subnet_id
  database-sg = module.security_group.database-sg
  owner       = var.owner
  db_username = var.db_username
  db_password = var.db_password
  db_name     = var.db_name
  naming      = var.naming
}

module "alb" {
  source       = "./modules/alb"
  eks_arn      = module.eks.oidc_provider_arn
  vpc_id       = module.vpc.vpc_id
  cluster_name = module.eks.cluster_name
}


module "status-page" {
  source                      = "./modules/status-page-helm"
  rds_endpoint                = module.rds.rds_endpoint
  db_name                     = var.db_name
  db_user                     = var.db_username
  rds_password                = var.db_password
  secret_key                  = var.secret_key
  superuser_name              = var.superuser_name
  superuser_password          = var.superuser_password
  superuser_email             = var.superuser_email
  image_repository_statuspage = var.image_repository_statuspage
  image_repository_nginx      = var.image_repository_nginx
}


module "monitoring" {
  source = "./modules/monitoring"
}

module "efk" {
  source  = "./modules/efk"
  eks_arn = module.eks.oidc_provider_arn
  region  = var.region
  cluster_name      = module.eks.cluster_name
}

module "route53" {
  source         = "./modules/route53"
  route53_name   = var.route53_name
  route53_zoneID = var.route53_zoneID
}
