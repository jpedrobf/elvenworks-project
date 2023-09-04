locals {
  name   = "elven-vpc"
  region = "sa-east-1"

  vpc_cidr        = "192.168.0.0/16"
  ## Az's são selecionadas manualmente pra dar possibilidade de customizar quais serão utilizadas 
  ## (e.g.: não queremos usar a AZ 'E', por costumar não ter uma boa quantidade de instâncias de última geração)
  azs             = ["sa-east-1a", "sa-east-1b", "sa-east-1c"]
  
  tags = {
    Example    = local.name
    GithubRepo = "github.com/jpedrobf/elvenworks-project"
    GithubOrg  = "elvenproject-sre"
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
    "192.168.0.0/22",
    "192.168.4.0/22",
    "192.168.8.0/22",
  ]
  database_subnets    = [
    "192.168.16.0/22",
    "192.168.20.0/22",
    "192.168.24.0/22",
  ]
  private_subnets     = [
    "192.168.32.0/19",
    "192.168.64.0/19",
    "192.168.96.0/19",
  ]
  
  single_nat_gateway = false
  enable_nat_gateway = true

  tags = local.tags
}