data "aws_caller_identity" "current" {}

resource "kubernetes_config_map" "aws_auth" {

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }
  data = {
    mapRoles = yamlencode(
        distinct(concat(
            local.configmap_roles,
            var.map_roles,
        ))
    )
    map_users    = yamlencode(var.map_users)
    map_accounts = yamlencode(var.map_accounts)
  }

  depends_on = [
    null_resource.wait_for_cluster
  ]
}

resource "kubernetes_priority_class" "priority_class_api-high" {
  metadata {
    name = "high-priority"
  }

  value = 1000000
  description = "This priority class should be used for critical services APIs only."
}

resource "kubernetes_priority_class" "priority_class_api" {
  metadata {
    name = "avg-api"
  }

  value = 1000
  description = "This priority class should be used for API pods only, without queue consumers."
}

resource "kubernetes_priority_class" "priority_class_worker" {
  metadata {
    name = "worker"
  }

  value = 10
  description = "This priority class should be used for all workers."
}

resource "kubernetes_priority_class" "priority_class_overprovisioning" {
  metadata {
    name = "overprovisioning"
  }

  value = -1
  description = "This priority class should be used for critical services APIs only."
}