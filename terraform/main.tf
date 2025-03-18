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
