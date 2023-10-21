variable "name" {
  description = "Name to be used on resources as identifier"
  type        = string
  default     = "elvenworks-project"
}
variable "region" {
  description = "AWS region"
  type        = string
  default     = "sa-east-1"
}
variable azs {
  description = "List of Availability Zones"
  type        = list(string)
  default     = ["sa-east-1a", "sa-east-1b", "sa-east-1c"]
}
variable vpc_cidr {
  description = "VPC cidr block"
  type        = string
  default     = "192.168.0.0/16"
}

variable public_subnets {
  description = "List of public subnets cidr blocks"
  type        = list(string)
  default     = ["192.168.0.0/22",
                 "192.168.4.0/22",
                 "192.168.8.0/22"
                ]
}

variable private_subnets {
  description = "List of private subnets cidr blocks"
  type        = list(string)
  default     = [ "192.168.32.0/19",
                  "192.168.64.0/19",
                  "192.168.96.0/19"
                ]
}

variable database_subnets {
  description = "List of database subnets cidr blocks"
  type        = list(string)
  default     = [ "192.168.16.0/22",
                  "192.168.20.0/22",
                  "192.168.24.0/22"
                ]
}
variable single_nat_gateway {
  description = "Single NAT Gateway"
  type        = bool
  default     = false
}

variable enable_nat_gateway {
  description = "Enable NAT Gateway"
  type        = bool
  default     = true
}

#### TAGS #### 
variable "environment" {
  description = "Environment to be used on all resources as identifier"
  type        = string
  default     = "dev"
}

variable "squad" {
  description = "Squad to be used on all resources as identifier"
  type        = string
  default     = "sre"
}

variable "bu" {
  description = "Business Unit to be used on all resources as identifier"
  type        = string
  default     = "tech_cross"
}

variable "tribe" {
  description = "Tribe to be used on all resources as identifier"
  type        = string
  default     = "tech_cross"
}

variable "cost_optimized" {
  description = "Cost optimized to be used on all resources as identifier"
  type        = string
  default     = "true"
}

variable "shared" {
  description = "Shared to be used on all resources as identifier"
  type        = string
  default     = "true"
}

variable "custom_tags" {
  type        = map(any)
  default     = {
    GithubRepo = "github.com/jpedrobf/elvenworks-project"
    GithubOrg  = "elvenproject-sre"
  }
  description = "A JSON containing additional tags"
}


variable "resource_identifier" {
  description = "Resource Identifier to be used on all resources as identifier"
  type        = string
  default     = "vpc"
}