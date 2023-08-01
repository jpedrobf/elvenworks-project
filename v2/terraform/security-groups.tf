resource "aws_security_group" "irt-worker-sg" {
  name_prefix = var.cluster_name
  description = "security group for EKS irt-project"
  vpc_id      = module.vpc.vpc-id #old: aws_vpc.irt-project.id

  tags = {
    Name      = "irt-worker-sg"
    #"kubernetes.io/cluster/irt-project" = "owned"
    #"aws:eks:cluster-name" = "irt-project"
  }

}

resource "aws_security_group_rule" "workers_egress_internet" {
  security_group_id = aws_security_group.irt-worker-sg.id
  description       = "Allow node all egress access to the Internet."
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  type              = "egress"

}

resource "aws_security_group_rule" "workers_ingress_self" {
  security_group_id        = aws_security_group.irt-worker-sg.id
  description              = "Allow node to communicate with each other."
  protocol                 = "-1"
  source_security_group_id = aws_security_group.irt-worker-sg.id
  from_port                = 0
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "workers_ingress_cluster" {
  security_group_id        = aws_security_group.irt-worker-sg.id
  description              = "Allow workers pods to receive communication from the cluster control plane."
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.cluster-sg.id
  from_port                = 0
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "workers_ingress_cluster_kubelet" {
  security_group_id        = aws_security_group.irt-worker-sg.id
  description              = "Allow workers Kubelets to receive communication from the cluster control plane."
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.cluster-sg.id
  from_port                = 10250
  to_port                  = 10250
  type                     = "ingress"
}

resource "aws_security_group_rule" "workers_ingress_cluster_https" {
  security_group_id        = aws_security_group.irt-worker-sg.id
  description              = "Allow pods running extension API servers on port 443 to receive communication from cluster control plane."
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.cluster-sg.id
  from_port                = 443
  to_port                  = 443
  type                     = "ingress"
}
resource "aws_security_group_rule" "workers_ingress_cluster_primary" {
  security_group_id        = aws_security_group.irt-worker-sg.id
  description              = "Allow pods running on workers to receive communication from cluster primary security group (e.g. Fargate pods)."
  protocol                 = "all"
  source_security_group_id = aws_security_group.cluster-sg.id
  from_port                = 0
  to_port                  = 65535
  type                     = "ingress"
}

