variable "region" {
  default = "us-east-2"

}

variable "profile_aws" {
  description = "Profile AWS"
  type        = string
  default     = "picpay-lab-irt"

}

variable "key_name" {
  type    = string
  default = "irt-node"

}


variable "type_instance" {
  description = "Type instance"
  type        = string
  default     = "t3.micro"
}


variable "tags" {
  type = map(any)

  default = {
    "bu" = "tech_cross"
  }

}

# ---------------

variable "autoscaling_group_tags" {
  description = "A map of additional tags to add to the autoscaling group created. Tags are applied to the autoscaling group only and are NOT propagated to instances"
  type        = map(string)
  default     = {}
}

variable "asg_max_size" {
  type    = string
  default = "10"

}

variable "asg_min_size" {
  type    = string
  default = "2"

}

variable "cluster_name" {
  description = "Name of the EKS cluster. Also used as a prefix in names of related resources."
  type        = string
  default     = "irt-project"
}

variable "cluster_version" {
  description = "Kubernetes Version to use on EKS Cluster"
  type        = string
  default     = "1.21"
}

variable "publicdestCIDRblock" {
  default = "0.0.0.0/0"
}

variable "iam_path" {
  description = "If provided, all IAM roles will be created on this path."
  type        = string
  default     = "/"
}
variable "map_roles" {
  description = "Additional IAM roles to add to the aws-auth configmap. See examples/basic/variables.tf for example format."
  type = list(object({
    rolearn  = string
    username = string
    groups   = list(string)
  }))
  default = [
    {
      rolearn  = "arn:aws:iam::035267315123:role/ManageOps"
      username = ":{{SessionName}}"
      groups   = ["system:masters"]
    },
    {
      rolearn  = "arn:aws:iam::035267315123:role/AWSReservedSSO_GeneralSRE_727d478ea7e30d08"
      username = "GeneralSRE:{{SessionName}}"
      groups   = ["system:masters"]
    }
  ]
}
variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap. See examples/basic/variables.tf for example format."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
  default = []
}
variable "map_accounts" {
  description = "Additional IAM accounts to add to the aws-auth configmap. See examples/basic/variables.tf for example format."
  type = list(string)
  default = []
}

variable "wait_for_cluster_cmd" {
  description = "Custom local-exec command to execute for determining if the eks cluster is healthy. Cluster endpoint will be available as an environment variable called ENDPOINT"
  type        = string
  default     = "for i in `seq 1 60`; do if `command -v wget > /dev/null`; then wget --no-check-certificate -O - -q $ENDPOINT/healthz >/dev/null && exit 0 || true; else curl -k -s $ENDPOINT/healthz >/dev/null && exit 0 || true;fi; sleep 5; done; echo TIMEOUT && exit 1"
}

variable "wait_for_cluster_interpreter" {
  description = "Custom local-exec command line interpreter for the command to determining if the eks cluster is healthy."
  type        = list(string)
  default     = ["/bin/sh", "-c"]
}

variable "eks_oidc_root_ca_thumbprint" {
  type        = string
  description = "Thumbprint of Root CA for EKS OIDC, Valid until 2037"
  default     = "9e99a48a9960b14926bb7f3b02e22da2b0ab7280"
}