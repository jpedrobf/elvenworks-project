### REQUIRED

variable "squad" {
  type        = string
  description = "The squad that owns the resource"
}

variable "bu" {
  type        = string
  description = "The bu that owns the resource"
}

variable "tribe" {
  type        = string
  description = "The tribe that owns the resource"
}


variable "cost_optimized" {
  type        = bool
  description = "If the service was cost optimized"
}

variable "shared" {
  type        = bool
  description = "If the service is shared with others squads"
}

variable "resource_identifier" {
  type        = string
  description = "The resource identifier, ex: ec2, s3, rds, etc..."
}

### OPTIONALS

variable "environment" {
  type        = string
  default     = null
  description = "The resource's environment"
}

variable "backup" {
  type        = string
  default     = ""
  description = "The resource's backup configuration. Only available for: Aurora, DocumentDB, DynamoDB, EBS, EC2, EFS, FSxIncludes FSx for Lustre, ONTAP, OpenZFS and Windows file server, Neptune,, RDS, Redshift, SAP HANA on Amazon EC2 - newView pre-requisites, Storage Gateway, Timestream, VMware virtual machines"
}

variable "application" {
  type        = string
  default     = ""
  description = "The application that will use the resource"
}

variable "name" {
  type        = string
  default     = ""
  description = "The name of the resource"
}

variable "custom_tags" {
  type        = map(any)
  default     = {}
  description = "A JSON containing additional tags"
}

variable "module" {
  type        = string
  default     = null
  description = "The module used to create or update the resource. It is important to remember that we must put the GitHub URL with the respective TAG"
}