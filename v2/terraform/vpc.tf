module "vpc" {
  source = "../terraform/vpc-module"
  vpc-cidr_block = "10.0.0.0/20"

  vpc-tags = { 
    Name = "vpc-irt-project"
  }
}