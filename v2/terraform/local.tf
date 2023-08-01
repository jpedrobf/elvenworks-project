locals {
  ec2_principal                = "ec2.${data.aws_partition.current.dns_suffix}"
  sts_principal                = "sts.${data.aws_partition.current.dns_suffix}"
  policy_arn_prefix            = "arn:${data.aws_partition.current.partition}:iam::aws:policy"
  pre_userdata                 = ""
  additional_userdata          = ""
  bootstrap_extra_args         = ""
  kubelet_extra_args           = "--node-labels=lifecycle=OnDemand,family=general"
  userdata_template_extra_args = {}

  ami_id = "ami-039996e8636e0549a"

  auth_launch_template_worker_roles = [{ 
      worker_role_arn = "arn:${
        data.aws_partition.current.partition
        }:iam::${
          data.aws_caller_identity.current.account_id
          }:role/${
            aws_iam_instance_profile.workers.role
            }" 
  }]
  
  configmap_roles = [
    for role in concat(
      local.auth_launch_template_worker_roles
    ) : {
      # Work around https://github.com/kubernetes-sigs/aws-iam-authenticator/issues/153
      # Strip the leading slash off so that Terraform doesn't think it's a regex
      rolearn  = replace(role["worker_role_arn"], replace(var.iam_path, "/^//", ""), "")
      username = "system:node:{{EC2PrivateDNSName}}"
      groups = tolist(concat(
        [
          "system:bootstrappers",
          "system:nodes",
        ],
      ))
    }
  ]


  k8s_service_account_namespace = "kube-system"
  k8s_service_account_name      = "cluster-autoscaler-aws-cluster-autoscaler-chart"
}
