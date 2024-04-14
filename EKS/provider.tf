provider "aws" {
  region = var.region
}

provider "kubernetes" {
  host = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command = "aws"
    args = [
      "eks",
      "get-token",
      "update-kubeconfig",
      "--name",
      var.cluster_name,
      "--region",
      var.region,
      "--kubeconfig"      
    ]
  }
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command = "aws"
    args = [
      "eks",
      "get-token",
      "update-kubeconfig",
      "--name",
      var.cluster_name,
      "--region",
      var.region,
      "--kubeconfig"     
    ]
    }
  }
}