terraform {
  backend "s3" {
    bucket = "sockshop-backend"
    region = "us-east-1"
    key    = "eks/terraform.tfstate"
    //dynamodb_table = "app-table"
  }
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.7.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "~> 3.5.1"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.4"
    }

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.3.2"
    }
  }

  required_version = "~> 1.3"
}

