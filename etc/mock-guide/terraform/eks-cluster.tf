resource "aws_eks_cluster" "irt-project" {
  name     = var.cluster_name
  version  = var.cluster_version
  role_arn = aws_iam_role.cluster.arn

  #kubernetes_network_config {
  #    ip_family = "ipv4"
  #}

  vpc_config {
    subnet_ids = [module.vpc.private-subnet-1-id, module.vpc.private-subnet-2-id]
    security_group_ids = [aws_security_group.irt-worker-sg.id]
    public_access_cidrs = [var.publicdestCIDRblock]
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster_AmazonEKSServicePolicy,
    aws_iam_role_policy_attachment.cluster_AmazonEKSVPCResourceControllerPolicy,
    aws_security_group_rule.cluster_egress_internet,
    aws_security_group_rule.cluster_https_worker_ingress
  ]

}
resource "null_resource" "wait_for_cluster" {
  depends_on = [
    aws_eks_cluster.irt-project
  ]
  provisioner "local-exec" {
    command     = var.wait_for_cluster_cmd
    interpreter = var.wait_for_cluster_interpreter
    environment = {
      ENDPOINT = aws_eks_cluster.irt-project.endpoint
    }
  }
}

