data "aws_partition" "current" {}
data "template_file" "launch_template_userdata" {
  #count = var.create_eks ? local.worker_group_launch_template_count : 0
  template = file("${path.module}/userdata/userdata.sh.tpl")

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

data "aws_iam_policy_document" "cluster_assume_role_policy" {
  statement {
    sid = "EKSClusterAssumeRole"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "workers_assume_role_policy" {
  statement {
    sid = "EKSWorkerAssumeRole"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = [local.ec2_principal]
    }
  }
}
