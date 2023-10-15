resource "aws_eks_addon" "vpc-cni" {
  cluster_name = var.cluster_name
  addon_name   = "vpc-cni"
  addon_version = "v1.11.2-eksbuild.1"

  depends_on = [
    aws_autoscaling_group.general_asg,
    aws_autoscaling_group.prometheus_asg,
    null_resource.wait_for_cluster
  ]
}

resource "aws_eks_addon" "coredns" {
  cluster_name = var.cluster_name
  addon_name   = "coredns"
  addon_version = "v1.8.4-eksbuild.1"
  
    depends_on = [
    aws_autoscaling_group.general_asg,
    aws_autoscaling_group.prometheus_asg,
    null_resource.wait_for_cluster
  ]
}