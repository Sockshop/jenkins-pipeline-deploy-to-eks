terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0.0"
    }

    kubernetes = {
        version = ">= 2.0.0"
        source = "hashicorp/kubernetes"
    }
  }
}


data "aws_eks_cluster" "sockshop-eks-cluster" {
  name = "sockshop-eks-cluster"
}
data "aws_eks_cluster_auth" "sockshop-eks-cluster_auth" {
  name = "sockshop-eks-cluster_auth"
}


provider "aws" {
  region     = "eu-west-3"
}



provider "helm" {
  kubernetes {
    host                   = aws_eks_cluster.cluster.endpoint
    cluster_ca_certificate = base64decode(aws_eks_cluster.cluster.certificate_authority[0].data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.cluster.id]
      command     = "aws"
    }
  }
}

resource "helm_release" "aws-load-balancer-controller" {
  name = "aws-load-balancer-controller"

  repository = "https://aws.github.io/eks-charts"
  chart      = "stable/aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = "2.7.2"

  set {
    name  = "clusterName"
    value = aws_eks_cluster.cluster.id
  }
  
  set {
    name  = "image.tag"
    value = "v2.7.2"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = "aws_iam_role.aws_load_balancer_controller.arn"
  }

  depends_on = [
    aws_eks_node_group.private-nodes,
    aws_iam_role_policy_attachment.aws_load_balancer_controller_attach
  ]
}