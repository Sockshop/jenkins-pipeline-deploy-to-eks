module "eks" {
    source  = "terraform-aws-modules/eks/aws"
    version = "~> 19.0"
    cluster_name = var.cluster_name
    cluster_version = "1.24"

    cluster_endpoint_public_access  = true

    vpc_id = module.myapp-vpc.vpc_id
    subnet_ids = module.myapp-vpc.private_subnets
    control_plane_subnet_ids = module.vpc.intra_subnets
    tags = {
        environment = "development"
        application = "myapp"
    }
    create_kms_key                 = false
    create_cloudwatch_log_group    = false
    # disable encyption so we dont need a key
    cluster_encryption_config      = {}
    
    cluster_addons = {
        coredns = {
            most_recent = true
        }
        kube-proxy = {
            most_recent = true
        }
        vpc-cni = {
            most_recent = true
        }
        # ebs csi driver to use velero backup
        /*aws-ebs-csi-driver = {
            most_recent = true
        }*/
    }

# define managed node group
    eks_managed_node_group_defaults = {
        ami_type = "AL2_x86_64"
    }   
    eks_managed_node_groups = {
        dev = {
            min_size = 1
            max_size = 3
            desired_size = 2

            instance_types = ["t2.small"]

            # role for ebs csi driver to use velero as backup solution
            iam_role_additional_policies = {
                AmazonEBSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"   
            }
        }
    }    
}
# ebs csi addon needed for velero "csi stand for Container Storage Interface"

# https://aws.amazon.com/blogs/containers/amazon-ebs-csi-driver-is-now-generally-available-in-amazon-eks-add-ons/ 
data "aws_iam_policy" "ebs_csi_policy" {
    arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

#OpenID Connect (OIDC)
module "irsa-ebs-csi" {
    source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
    version = "4.7.0"

    create_role                   = true
    role_name                     = "AmazonEKSTFEBSCSIRole-${module.eks.cluster_name}"
    provider_url                  = module.eks.oidc_provider
    role_policy_arns              = [data.aws_iam_policy.ebs_csi_policy.arn]
    oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
}

resource "aws_eks_addon" "ebs-csi" {
    cluster_name             = module.eks.cluster_name
    addon_name               = "aws-ebs-csi-driver"
    addon_version            = "v1.27.0-eksbuild.1"
    service_account_role_arn = module.irsa-ebs-csi.iam_role_arn
    tags = {
        "eks_addon" = "ebs-csi"
        "terraform" = "true"
    }
}
