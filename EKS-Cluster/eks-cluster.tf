module "eks" {
    source          = "terraform-aws-modules/eks/aws"
    version = "~> 19.0"
    cluster_name    = var.cluster_name
    cluster_version = "1.28"

    cluster_endpoint_public_access = true

    vpc_id                   = module.vpc.vpc_id
    subnet_ids               = module.vpc.private_subnets
    
    tags = {
      environment = "dev"
      application = "sock-shop-app"
      terraform = true
    }
    
    eks_managed_node_groups = {
      nodes = {
        min_size     = 1
        max_size     = 3
        desired_size = 2

        instance_types = ["t2.medium"]   
      }
    }
}    


