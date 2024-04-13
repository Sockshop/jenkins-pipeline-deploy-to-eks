#EKS
module "eks" {
  source                         = "terraform-aws-modules/eks/aws"
  cluster_name    = var.cluster_name
  cluster_version                = "1.29"
  cluster_endpoint_public_access = true
  vpc_id                         = module.vpc.vpc_id
  subnet_ids                     = module.vpc.private_subnets

  # no key managed by kms (permission issue)
  create_kms_key                 = false
  create_cloudwatch_log_group    = false
  # disable encyption so we dont need a key
  cluster_encryption_config      = {}

  eks_managed_node_groups = {
    nodes = {
      min_size       = 1
      max_size       = 3
      desired_size   = 2
      instance_types = var.instance_types
    }
  }
  tags = {
    Environment = "dev"
    Terraform   = "true"
    application = "sockshop-App"
  }
}