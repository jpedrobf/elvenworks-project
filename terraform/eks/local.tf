locals {
  account_id = data.aws_caller_identity.current.account_id
  name            = "elven-cluster"
  cluster_version = "1.26"
  region = "sa-east-1"

  # network configurations 
  vpc_cidr = "192.168.0.0/16"
  vpc_id   = "vpc-028d8a82ad4c1921a"
  subnet_ids               = ["subnet-06e9656596980d2f3", "subnet-0a866705f5d7c6a97", "subnet-0e30b8f58d262c9f8"]
  control_plane_subnet_ids = ["subnet-06e9656596980d2f3", "subnet-0a866705f5d7c6a97", "subnet-0e30b8f58d262c9f8"]
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