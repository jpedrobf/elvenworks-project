# necessary IAM role and policies for worker nodes

resource "aws_iam_role" "workers" {
  name_prefix        = var.cluster_name
  assume_role_policy = data.aws_iam_policy_document.workers_assume_role_policy.json

}

resource "aws_iam_instance_profile" "workers" {
  name_prefix = var.cluster_name
  role        = aws_iam_role.workers.name

}

resource "aws_iam_role_policy_attachment" "workers_AmazonEKSWorkerNodePolicy" {
  policy_arn = "${local.policy_arn_prefix}/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.workers.name

}

resource "aws_iam_role_policy_attachment" "workers_AmazonEKS_CNI_Policy" {
  policy_arn = "${local.policy_arn_prefix}/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.workers.name

}

resource "aws_iam_role_policy_attachment" "workers_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "${local.policy_arn_prefix}/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.workers.name
}

resource "aws_iam_role_policy_attachment" "workers_AmazonSSMFullAccess" {
  policy_arn = "${local.policy_arn_prefix}/AmazonSSMFullAccess"
  role       = aws_iam_role.workers.name
}