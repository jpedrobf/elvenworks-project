data "aws_region" "current" {}

locals {
  environment_map = {
    "dev"  = "dev"
    "qa"   = "qa"
    "hml"  = "hml"
    "hom"  = "hom"
    "prd"  = "prd"
    "prod" = "prod"
  }

  region_abbreviations = {
    us-east-2      = "use2",
    us-east-1      = "use1",
    us-west-1      = "usw1",
    us-west-2      = "usw2",
    af-south-1     = "afa1",
    ap-east-1      = "ape1",
    ap-south-1     = "aps1",
    ap-northeast-3 = "apn3",
    ap-northeast-2 = "apn2",
    ap-southeast-1 = "apse1",
    ap-southeast-2 = "apse2",
    ap-northeast-1 = "apn1",
    ca-central-1   = "cac1",
    eu-central-1   = "euc1",
    eu-west-1      = "euw1",
    eu-west-2      = "euw2",
    eu-south-1     = "eus1",
    eu-west-3      = "euw3",
    eu-north-1     = "eun1",
    me-south-1     = "mes1",
    sa-east-1      = "sae1",
  }

  aws_region = local.region_abbreviations[data.aws_region.current.name]

  environment         = var.environment != null ? lower(trimspace(var.environment)) : null
  application         = lower(trimspace(var.application))
  squad               = lower(trimspace(var.squad))
  bu                  = lower(trimspace(var.bu))
  tribe               = lower(trimspace(var.tribe))
  resource_identifier = lower(trimspace(var.resource_identifier))
  backup              = lower(trimspace(var.backup))
  cost_optimized      = var.cost_optimized
  shared              = var.shared
  module              = var.module != null ? lower(trimspace(var.module)) : null

  #name = replace("aws-${local.resource_identifier}-${var.name}-${local.aws_region}-${local.environment}", "_", "-")

  tags_optional = {
    #"Name"        = local.name
    "application" = local.application
    "environment" = local.environment_map[local.environment]
  }

  tags_optional_normalized = local.module != null ? merge({ "module" = local.module }, local.tags_optional) : local.tags_optional
  tags_optional_map        = local.environment != null ? merge({ "environment" = local.environment_map[local.environment] }, local.tags_optional_normalized) : local.tags_optional_normalized

  required_tags = {
    "squad"          = local.squad
    "bu"             = local.bu
    "tribe"          = local.tribe
    "cost_optimized" = local.cost_optimized
    "shared"         = local.shared
    "terraform"      = true
    "managed_by"     = "test-elvenwork-project"
  }

  custom = merge(local.tags_optional_map, local.required_tags, var.custom_tags)
}