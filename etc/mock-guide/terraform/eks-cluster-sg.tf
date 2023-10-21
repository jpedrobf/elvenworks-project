resource "aws_security_group" "cluster-sg" {
  name_prefix = var.cluster_name
  description = "EKS cluster security group."
  vpc_id = module.vpc.vpc-id

  tags = {
    "Name" = "${var.cluster_name}-eks_cluster_sg"
  }
}

resource "aws_security_group_rule" "cluster_egress_internet" {
  security_group_id = aws_security_group.cluster-sg.id
  description       = "Allow cluster egress access to the Internet."
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  type              = "egress"
}

resource "aws_security_group_rule" "cluster_primary_ingress_workers" {
  security_group_id        = aws_security_group.cluster-sg.id
  description              = "Allow pods running on workers to send communication to cluster primary security group (e.g. Fargate pods)."
  protocol                 = "all"
  source_security_group_id = aws_security_group.irt-worker-sg.id
  from_port                = 0
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "cluster_https_worker_ingress" {
  security_group_id        = aws_security_group.cluster-sg.id
  description              = "Allow pods to communicate with the EKS cluster API."
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.irt-worker-sg.id
  from_port                = 443
  to_port                  = 443
  type                     = "ingress"
}