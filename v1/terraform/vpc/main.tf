locals {
  name   = "ex-${basename(path.cwd)}"
  region = "us-west-2"

  vpc_cidr        = "10.0.0.0/16"
  ## Az's são selecionadas manualmente pra dar possibilidade de customizar quais serão utilizadas 
  ## (e.g.: não queremos usar a AZ 'E', por costumar não ter uma boa quantidade de instâncias de última geração)
  azs             = ["us-west-2a", "us-west-2b", "us-west-2c", "us-west-2d"]
  
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
  public_subnets      = [
    "10.0.0.0/22",
    "10.0.4.0/22",
    "10.0.8.0/22",
    "10.0.12.0/22"
  ]
  intra_subnets    = [
    "10.0.16.0/22",
    "10.0.20.0/22",
    "10.0.24.0/22",
    "10.0.28.0/22"
  ]
  private_subnets     = [
    "10.0.32.0/19",
    "10.0.64.0/19",
    "10.0.96.0/19",
    "10.0.128.0/19"
  ]
  
  single_nat_gateway = false
  enable_nat_gateway = true

  tags = local.tags
}