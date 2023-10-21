locals { 

    # nodegroup one configurations
    nodegroup_one_name = "apps1"
    nodegroup_one_use_name_prefix = false
    nodegroup_one_minsize     = 1
    nodegroup_one_maxsize     = 5
    nodegroup_one_desiredsize = 1
    nodegroup_one_launch_template_name            = "${module.eks.cluster_name}-${local.nodegroup_one_name}"
    nodegroup_one_launch_template_use_name_prefix = false
    nodegroup_one_launch_template_description     = "Self managed node group for ${local.nodegroup_one_name} nodes"
    
    # nodegroup two configurations
    nodegroup_two_name = "monitoring"
    nodegroup_two_use_name_prefix = false
    nodegroup_two_minsize = 1
    nodegroup_two_maxsize = 2
    nodegroup_two_desiredsize = 1
    nodegroup_two_launch_template_name            = "${module.eks.cluster_name}-${local.nodegroup_two_name}"
    nodegroup_two_launch_template_use_name_prefix = false
    nodegroup_two_launch_template_description     = "Self managed node group for ${local.nodegroup_two_name} nodes"
    

    # common nodegroup configurations
    block_device_mappings = {
        xvda = {
            device_name = "/dev/xvda"
            ebs = {
            volume_size           = 100
            volume_type           = "gp3"
            iops                  = 3000
            throughput            = 150
            encrypted             = true
            kms_key_id            = module.ebs_kms_key.key_arn
            delete_on_termination = true
            }
        }
        }
    metadata_options = {
        http_endpoint               = "enabled"
        http_tokens                 = "required"
        http_put_response_hop_limit = 2
        instance_metadata_tags      = "disabled"
      }

    ebs_optimized     = true
    enable_monitoring = true
    # end of common nodegroup configurations
}