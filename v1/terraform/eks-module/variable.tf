variable "nodegroup_one_minsize" {
  description = "min number of nodes of the asg 'One'"
  type        = string
  default     = "1"

}

variable "nodegroup_one_maxsize" {
  description = "max number of nodes of the asg 'One'"
  type        = string
  default     = "5"

}


variable "nodegroup_one_desiredsize" {
  description = "desired number of nodes of the asg 'One'"
  type        = string
  default     = "1"

}