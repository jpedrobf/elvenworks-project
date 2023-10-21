#resource "aws_network_interface" "irt-teste" {
#    subnet_id = aws_subnet.public-subnet-1.id
#    security_groups = [aws_security_group.sg-teste.id]
#}
#
#resource "aws_instance" "irt-teste" {
#  ami                    = "ami-0960ab670c8bb45f3"
#  instance_type          = var.type_instance
#  key_name               = var.key_name
#  network_interface {
#    network_interface_id = aws_network_interface.irt-teste.id
#    device_index = 0
#  }
#
#  volume_tags = {
#    Name = "irt-teste"
#    bu = "tech_cross"
#  }
#  tags = {
#    Name = "irt-teste"
#  }
#  root_block_device {
#    volume_size = 50
#    volume_type = "gp2"
#  }
# 
#}
#
#resource "aws_security_group" "sg-teste" {
#  name_prefix = var.cluster_name
#  description = "security group for ec2 irt-teste"
#  vpc_id      = aws_vpc.irt-project.id
#
#  tags = {
#    Name      = "sg-teste"
#  }
#}
#
#resource "aws_security_group_rule" "teste_egress_internet" {
#  security_group_id = aws_security_group.sg-teste.id
#  description       = "Allow egress access to the Internet."
#  protocol          = "-1"
#  cidr_blocks       = ["0.0.0.0/0"]
#  from_port         = 0
#  to_port           = 0
#  type              = "egress"
#
#}
#
#resource "aws_security_group_rule" "teste_ssh" {
#  security_group_id = aws_security_group.sg-teste.id
#  description       = "Allow all access into ec2 for lab purposes"
#  protocol          = "-1"
#  cidr_blocks       = ["0.0.0.0/0"]
#  from_port         = 0
#  to_port           = 0
#  type              = "ingress"
#}
#
#