locals {
  account_id = data.aws_caller_identity.current.account_id
  name            = "elven-cluster"
  cluster_version = "1.26"
  region = "sa-east-1"

  # network configurations 
  vpc_cidr = "192.168.0.0/16"
  vpc_id   = "vpc-0cc2b6cb1ade1d04c"
  subnet_ids               = ["subnet-09615b01388609df5", "subnet-07cad8133995f8bbe", "subnet-07f9e510ee49dd667"]
  control_plane_subnet_ids = ["subnet-09615b01388609df5", "subnet-07cad8133995f8bbe", "subnet-07f9e510ee49dd667"]
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)
  # end of network configurations

  # variables for tag module 
  environment = "dev"
  squad      = "sre"
  bu       = "tech_cross"
  tribe    = "tech_cross"
  cost_optimized = "true"
  shared = "true"
  custom_tags = {
    "Project" = "elvenworks-project"
    "GithubRepo" = "github.com/jpedrobf/elvenworks-project"
    "GithubOrg"  = "elvenproject-sre"
  }
  resource_identifier = "eks-cluster-resources"
}