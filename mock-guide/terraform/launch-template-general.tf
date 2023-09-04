resource "aws_launch_template" "general_launch_template" {
  name = "${var.cluster_name}-general-nodegroup-template"
  description = "Terraform Default Launch-Template"
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
      volume_size           = 50
      volume_type           = "gp2"
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
    data.template_file.launch_template_userdata.rendered,
  )
  tag_specifications {
    resource_type = "instance"
    tags = { #@todo - tag Name = "${var.cluster_name}-${var.cluster_version}-asg-${numerorandom?}"
      bu      = "tech_cross"
      project = "irt-project"
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
