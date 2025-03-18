module "vpc" {
  source                 = "./modules/vpc"
  vpc_cidr               = var.vpc_cidr
  public_subnet_cidr     = var.public_subnet_cidr
  public_subnet_cidr_az2 = var.public_subnet_cidr_az2
  private_subnet_cidr    = var.private_subnet_cidr
  availability_zones     = var.availability_zones
}

module "security_groups" {
  source              = "./modules/security_group"
  vpc_id              = module.vpc.vpc_id
  owner               = var.owner
  private_subnet_cidr = var.private_subnet_cidr
  from_port           = var.from_port
  to_port             = var.to_port
}
