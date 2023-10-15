module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"
  cluster_name    = local.name
  cluster_version = local.cluster_version
  

  cluster_endpoint_public_access  = true

  vpc_id                   = local.vpc_id
  subnet_ids               = local.subnet_ids
  control_plane_subnet_ids = local.control_plane_subnet_ids

  # Self managed node groups will not automatically create the aws-auth configmap so we need to
  create_aws_auth_configmap = true
  manage_aws_auth_configmap = true


  # # Self Managed Node Group(s)
  self_managed_node_group_defaults = {
    # enable discovery of autoscaling groups by cluster-autoscaler
    autoscaling_group_tags = {
      "k8s.io/cluster-autoscaler/enabled" : true,
      "k8s.io/cluster-autoscaler/${local.name}" : "owned",
    }
  }

   self_managed_node_groups = {
    # Default node group - as provisioned by the module defaults
    default_node_group = {}
    one = {
      name            = "monitoring"
      use_name_prefix = false
      ami_id = data.aws_ami.eks_default.id
      subnet_ids = local.subnet_ids

      min_size     = local.nodegroup_one_minsize
      max_size     = local.nodegroup_one_maxsize
      desired_size = local.nodegroup_one_desiredsize

      launch_template_name            = "self-managed-monitoring"
      launch_template_use_name_prefix = true
      launch_template_description     = "Self managed node group for monitoring nodes"
      ebs_optimized     = true
      enable_monitoring = true

      block_device_mappings = local.block_device_mappings

      metadata_options = {
        http_endpoint               = "enabled"
        http_tokens                 = "required"
        http_put_response_hop_limit = 2
        instance_metadata_tags      = "disabled"
      }
    }
    two = {
      name            = "monitoring"
      use_name_prefix = false
      ami_id = data.aws_ami.eks_default.id
      subnet_ids = local.subnet_ids

      min_size     = local.nodegroup_one_minsize
      max_size     = local.nodegroup_one_maxsize
      desired_size = local.nodegroup_one_desiredsize

      launch_template_name            = "self-managed-apps1"
      launch_template_use_name_prefix = true
      launch_template_description     = "Self managed node group for apps1 nodes"
      ebs_optimized     = true
      enable_monitoring = true

      block_device_mappings = local.block_device_mappings

      metadata_options = {
        http_endpoint               = "enabled"
        http_tokens                 = "required"
        http_put_response_hop_limit = 2
        instance_metadata_tags      = "disabled"
      }
    }

      

      # create_iam_role          = false
      # iam_role_name            = "eks-self-managed-nodegroup"
      # iam_role_use_name_prefix = false
      # iam_role_description     = "EKS self-managed node group role"
      # iam_role_tags = {
      #   Purpose = "Protector of the kubelet"
      # }
      # cluster_timeouts = {
      #   create = "80m"
      #   update = "80m"
      #   delete = "80m"
      # }
    }


  ###########################

  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::66666666666:role/role1"
      username = "role1"
      groups   = ["system:masters"]
    },
  ]


 cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }
  tags = {
    Environment = "dev"
    Terraform   = "true"
  }

}

module "key_pair" {
  source  = "terraform-aws-modules/key-pair/aws"
  version = "~> 2.0"

  key_name_prefix    = local.name
  create_private_key = true

  tags = local.tags
}
module "ebs_kms_key" {
  source  = "terraform-aws-modules/kms/aws"
  version = "~> 1.5"

  description = "Customer managed key to encrypt EKS managed node group volumes"

  # Policy
  key_administrators = [
    data.aws_caller_identity.current.arn
  ]

  key_service_roles_for_autoscaling = [
    # required for the ASG to manage encrypted volumes for nodes
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling",
    # required for the cluster / persistentvolume-controller to create encrypted PVCs
    module.eks.cluster_iam_role_arn,
  ]

  # Aliases
  aliases = ["eks/${local.name}/ebs"]

}
resource "aws_iam_policy" "additional" {
  name        = "${local.name}-additional"
  description = "Example usage of node additional policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })

  tags = local.tags
}