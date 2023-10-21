data "template_file" "launch_template_userdata-prometheus" {
  #count = var.create_eks ? local.worker_group_launch_template_count : 0
  template = file("${path.module}/userdata/userdata-prom.sh.tpl")

  vars = merge({
    cluster_name         = var.cluster_name
    endpoint             = aws_eks_cluster.irt-project.endpoint
    cluster_auth_base64  = aws_eks_cluster.irt-project.certificate_authority[0].data
    pre_userdata         = local.pre_userdata
    additional_userdata  = local.additional_userdata
    bootstrap_extra_args = local.bootstrap_extra_args
    kubelet_extra_args   = local.kubelet_extra_args
    },
    local.userdata_template_extra_args
  )
}

resource "aws_launch_template" "prometheus_launch_template" {
  name = "${var.cluster_name}-prometheus-nodegroup-template"
  description = "Terraform Prometheus Launch-Template"
  key_name    = "irt-node"
  image_id    = local.ami_id
  instance_type = "m5a.large" # if launch template will be used on an ASG with multiple instance types, remove this line

  metadata_options {
    http_endpoint = "enabled"
    http_tokens = "optional"
    http_put_response_hop_limit = null
  }

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size           = 100
      volume_type           = "gp3"
      delete_on_termination = true
    }
  }
  monitoring {
    enabled = true
  }
  iam_instance_profile {
    arn = aws_iam_instance_profile.workers.arn

  }
  network_interfaces {
    associate_public_ip_address = false
    delete_on_termination       = true
    security_groups             = [aws_security_group.irt-worker-sg.id]
  }

  user_data = base64encode(
    data.template_file.launch_template_userdata-prometheus.rendered,
  )
  tag_specifications {
    resource_type = "instance"
    tags = { #@todo - tag Name = "${var.cluster_name}-${var.cluster_version}-asg-${numerorandom?}"
      bu      = "tech_cross"
      project = "irt-project"
      "cluster/workload" = "prometheus"
      "kubernetes.io/cluster/irt-project" = "owned"
      "k8s.io/cluster-autoscaler/enabled" = "true"
      "k8s.io/cluster-autoscaler/irt-project" = "owned"
    }
  }
  tag_specifications {
    resource_type = "volume"
    tags = {
      bu      = "tech_cross"
      project = "irt-project"
    }
  }
}
