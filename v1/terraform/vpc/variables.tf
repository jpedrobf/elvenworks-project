variable "region" {
  description = "AWS region"
  type        = string
  default     = "sa-east-1"
}

variable "name" {
  description = "Name to be used on all resources as identifier"
  type        = string
  default     = "elvenworks-project"
}

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
  default     = {}
  description = "A JSON containing additional tags"
}


variable "resource_identifier" {
  description = "Resource Identifier to be used on all resources as identifier"
  type        = string
  default     = "vpc"
}