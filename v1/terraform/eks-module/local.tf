locals {
  name            = "elven-cluster"
  cluster_version = "1.26"
  region = "us-west-2"

  
  vpc_cidr = "10.0.0.0/16"
  vpc_id   = "vpc-b363de13"
  subnet_ids               = ["subnet-f97fbf79", "subnet-0ba595e2", "subnet-fd676806", "subnet-19ce8a14"]
  control_plane_subnet_ids = ["subnet-f97fbf79", "subnet-0ba595e2", "subnet-fd676806", "subnet-19ce8a14"]
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    Example    = local.name
    GithubRepo = "terraform-aws-eks"
    GithubOrg  = "terraform-aws-modules"
  }

  nodegroup_one_minsize     = 1
  nodegroup_one_maxsize     = 5
  nodegroup_one_desiredsize = 1

  block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 100
            volume_type           = "gp3"
            iops                  = 3000
            throughput            = 150
            encrypted             = true
            kms_key_id            = module.ebs_kms_key.key_arn
            delete_on_termination = true
          }
        }
      }
}