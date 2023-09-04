# provider "aws" {

#   access_key                  = "mock_access_key"
#   secret_key                  = "mock_secret_key"
#   region                      = "us-east-1"

#   s3_use_path_style           = true
#   skip_credentials_validation = true
#   skip_metadata_api_check     = true
#   skip_requesting_account_id  = true

#   endpoints {
#     s3             = "http://s3.localhost.localstack.cloud:4566"
#   }
# }

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      #version = "~> 5.7.0"
    }
  }

  # backend "s3" {
  #   bucket         = "elven-project-tf-remote-backend"
  #   key            = "terraform.tfstate"
  #   dynamodb_table = "elven-project-remote-backend"
  #   encrypt        = true
  #   region         = "us-west-1"
  #   profile        = "lab"
  # }
}
provider "aws" {
  region                   = var.region
  shared_credentials_files = [pathexpand("~/.aws/credentials")]
  profile                  = "lab"

  default_tags {
    tags = {
      bu        = "tech_cross"
      project   = "elvenworks-project"
      squad     = "sre"
      terraform = "true"
    }
  }
}

# provider "template" {
# }
# provider "null" {
# }
# data "aws_eks_cluster" "cluster" {
#   name = var.cluster_name
# }
# data "aws_eks_cluster_auth" "cluster" {
#   name = var.cluster_name
# }
# provider "kubernetes" {
#   host                   = data.aws_eks_cluster.cluster.endpoint
#   cluster_ca_certificate = base64decode(
#     data.aws_eks_cluster.cluster.certificate_authority.0.data
#     )
#   token                  = data.aws_eks_cluster_auth.cluster.token
# }