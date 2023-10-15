output "cluster_endpoint" {
  value = aws_eks_cluster.irt-project.endpoint
  depends_on = [null_resource.wait_for_cluster]
}

output "cluster_certificate_authority_data" {
  description = "Nested attribute containing certificate-authority-data for your cluster. This is the base64 encoded certificate data required to communicate with your cluster."
  value = aws_eks_cluster.irt-project.certificate_authority[0].data
  depends_on = [null_resource.wait_for_cluster]
}

output "cluster_id" {
  description = "The name/id of the EKS cluster. Will block on cluster creation until the cluster is really ready"
  value       = aws_eks_cluster.irt-project.id
  # So that calling plans wait for the cluster to be available before attempting
  # to use it. They will not need to duplicate this null_resource
  depends_on = [null_resource.wait_for_cluster]
}

output "cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the cluster."
  value       = aws_eks_cluster.irt-project.arn
}

output "cluster_version" {
  description = "The Kubernetes server version for the EKS cluster."
  value       = aws_eks_cluster.irt-project.version
}

output "config_map_aws_auth" {
  description = "A kubernetes configuration to authenticate to this EKS cluster."
  value       = kubernetes_config_map.aws_auth.*
}

output "oidc_provider_arn" {
  description = "The ARN of the OIDC Provider"
  value       = aws_iam_openid_connect_provider.oidc_provider[*].arn
}

output "eks_ca_iam_role_arn" {
  value = aws_iam_role.cluster-autoscaler.arn
  description = "AWS IAM role ARN for EKS Cluster Autoscaler"
}