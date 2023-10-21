provider "aws" {
  region                   = local.region
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

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    # This requires the awscli to be installed locally where Terraform is executed
    args = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}

provider "null" {
}