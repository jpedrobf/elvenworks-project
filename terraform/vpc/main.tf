module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.name
  cidr = var.vpc_cidr

  azs                 = var.azs
  public_subnets      = var.public_subnets
  database_subnets    = var.database_subnets
  private_subnets     = var.private_subnets
  single_nat_gateway  = var.single_nat_gateway
  enable_nat_gateway  = var.enable_nat_gateway
  tags                = module.tags.custom
}

module "tags" { 
  source  = "../tags"

  environment         = var.environment
  squad               = var.squad
  bu                  = var.bu
  tribe               = var.tribe
  cost_optimized      = var.cost_optimized
  shared              = var.shared
  custom_tags         = var.custom_tags
  resource_identifier = var.resource_identifier
}