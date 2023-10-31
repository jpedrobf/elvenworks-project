module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"
  cluster_name    = local.name
  cluster_version = local.cluster_version
  tags = module.tags.custom

  cluster_endpoint_public_access  = true

  vpc_id                   = local.vpc_id
  subnet_ids               = local.subnet_ids
  control_plane_subnet_ids = local.control_plane_subnet_ids

  # Self managed node groups will not automatically create the aws-auth configmap so we need to
  create_aws_auth_configmap = true
  manage_aws_auth_configmap = true


  # # Self Managed Node Group(s)
  self_managed_node_groups = {
    # Default node group - as provisioned by the module defaults, used for critical addons like cluster-autoscaler and coredns
    default_node_group = {
      bootstrap_extra_args            = "--kubelet-extra-args '--node-labels=workload=critical'"
      tags = {
        "k8s.io/cluster-autoscaler/enabled" : true,
        "k8s.io/cluster-autoscaler/${local.name}" : "owned",
      }
    }
    one = {
      name                            = local.nodegroup_one_name
      use_name_prefix                 = local.nodegroup_one_use_name_prefix
      ami_id                          = data.aws_ami.eks_default.id
      subnet_ids                      = local.subnet_ids
      min_size                        = local.nodegroup_one_minsize
      max_size                        = local.nodegroup_one_maxsize
      desired_size                    = local.nodegroup_one_desiredsize
      launch_template_name            = local.nodegroup_one_launch_template_name
      launch_template_use_name_prefix = local.nodegroup_one_launch_template_use_name_prefix
      launch_template_description     = local.nodegroup_one_launch_template_description
      ebs_optimized                   = local.ebs_optimized
      enable_monitoring               = local.enable_monitoring
      block_device_mappings           = local.block_device_mappings
      metadata_options                = local.metadata_options
      enable_bootstrap_user_data      = true 
      pre_bootstrap_user_data         = local.pre_bootstrap_user_data
      bootstrap_extra_args            = "--kubelet-extra-args '--node-labels=workload=${local.nodegroup_one_name}'"
      post_bootstrap_user_data        = local.post_bootstrap_user_data
      instance_type                   = "t3.medium"
      tags = {
        "k8s.io/cluster-autoscaler/enabled" : true,
        "k8s.io/cluster-autoscaler/${local.name}" : "owned",
      }
    }
    two = {
      name                            = local.nodegroup_two_name
      use_name_prefix                 = local.nodegroup_two_use_name_prefix
      ami_id                          = data.aws_ami.eks_default.id
      subnet_ids                      = local.subnet_ids
      min_size                        = local.nodegroup_two_minsize
      max_size                        = local.nodegroup_two_maxsize
      desired_size                    = local.nodegroup_two_desiredsize
      launch_template_name            = local.nodegroup_two_launch_template_name
      launch_template_use_name_prefix = local.nodegroup_two_launch_template_use_name_prefix
      launch_template_description     = local.nodegroup_two_launch_template_description
      ebs_optimized                   = local.ebs_optimized
      enable_monitoring               = local.enable_monitoring
      block_device_mappings           = local.block_device_mappings
      metadata_options                = local.metadata_options
      enable_bootstrap_user_data      = true 
      pre_bootstrap_user_data         = local.pre_bootstrap_user_data
      bootstrap_extra_args            = "--kubelet-extra-args '--node-labels=workload=${local.nodegroup_two_name}'"
      post_bootstrap_user_data        = local.post_bootstrap_user_data
      instance_type                   = "t3.medium"
      tags = {
        "k8s.io/cluster-autoscaler/enabled" : true,
        "k8s.io/cluster-autoscaler/${local.name}" : "owned",
      }
    }

      

  }

  aws_auth_roles = [
    {
      rolearn  = "arn:aws:iam::${local.account_id}:role/aws-reserved/sso.amazonaws.com/AWSReservedSSO_GeneralSRE_727d478ea7e30d08"
      username = "GeneralSRE"
      groups   = ["system:masters"]
    },
  ]


 cluster_addons = {
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

}

module "key_pair" {
  source  = "terraform-aws-modules/key-pair/aws"
  version = "~> 2.0"

  key_name_prefix    = local.name
  create_private_key = true
}

module "tags" { 
  source  = "../tags"

  environment         = local.environment
  squad               = local.squad
  bu                  = local.bu
  tribe               = local.tribe
  cost_optimized      = local.cost_optimized
  shared              = local.shared
  custom_tags         = local.custom_tags
  resource_identifier = local.resource_identifier
}