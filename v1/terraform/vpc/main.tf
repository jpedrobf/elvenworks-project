locals {
  name   = "ex-${basename(path.cwd)}"
  region = "eu-west-1"

  vpc_cidr        = "10.0.0.0/16"
  ## Az's são selecionadas manualmente pra dar possibilidade de customizar quais serão utilizadas 
  ## (e.g.: não queremos usar a AZ 'E', por costumar não ter uma boa quantidade de instâncias de última geração)
  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c", "eu-west-1d"]

  tags = {
    Example    = local.name
    GithubRepo = "terraform-aws-vpc"
    GithubOrg  = "terraform-aws-modules"
  }
}

################################################################################
# VPC Module
################################################################################

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = local.name
  cidr = local.vpc_cidr

  azs                 = local.azs
  private_subnets     = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  public_subnets      = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 4)]

  single_nat_gateway = true
  enable_nat_gateway = true

  tags = local.tags
}