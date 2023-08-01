#eks worker nodes ASG
resource "aws_autoscaling_group" "prometheus_asg" {
  name = join(
    "-",
    compact([
      var.cluster_name,
      aws_launch_template.prometheus_launch_template.name
    ])
  )
  
  max_size              = var.asg_max_size
  min_size              = var.asg_min_size
  force_delete          = false
  vpc_zone_identifier   = [module.vpc.private-subnet-1-id, module.vpc.private-subnet-2-id]
  protect_from_scale_in = false
  max_instance_lifetime = 0    # Maximum number of seconds instances can run in the ASG. 0 is unlimited.
  default_cooldown      = null # The amount of time, in seconds, after a scaling activity completes before another scaling activity can start.
  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity = 0
      on_demand_percentage_above_base_capacity = 0
      spot_allocation_strategy = "lowest-price"
      spot_instance_pools = 2
    }
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.prometheus_launch_template.id
        version            = "$Latest"
      }
      override {
        instance_type = "m5a.large"
      }
      override {
        instance_type = "m5a.xlarge"
      }
    }
  }
  depends_on = [
    aws_eks_cluster.irt-project
  ]
  
  dynamic "tag" {
    for_each = merge(
      {
        "Name"                                      = "${var.cluster_name}-${var.cluster_version}-eks_asg"
        "kubernetes.io/cluster/${var.cluster_name}" = "owned"
        "k8s.io/cluster/${var.cluster_name}"        = "owned"
      },
      var.tags
    )

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  dynamic "tag" {
    for_each = var.autoscaling_group_tags

    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = false
    }
  }
  # tag = [
  #       {
  #         "key" = "Name"
  #         "value" = "${var.cluster_name}-${var.cluster_version}-eks_asg"
  #         "propagate_at_launch" = true
  #       },
  #       {
  #         "key"                 = "kubernetes.io/cluster/${var.cluster_name}"
  #         "value"               = "owned"
  #         "propagate_at_launch" = true
  #       },
  #       {
  #         "key"                 = "k8s.io/cluster-autoscaler/${var.cluster_name}"
  #         "value"               = "owned"
  #         "propagate_at_launch" = true
  #       },
  #       {
  #         "key"                 = "k8s.io/cluster-autoscaler/enabled"
  #         "value"               = "true"
  #         "propagate_at_launch" = true
  #       },
  #       {
  #         "key"                 = "${var.cluster_name}/workload"
  #         "value"               = "prometheus"
  #         "propagate_at_launch" = true
  #       }
  #     ]
}
