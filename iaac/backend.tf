terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.41.0"
    }
  }

  backend "s3" {
    bucket = "sockshop-project-backend"
    region = "eu-west-3"
    key    = "sockshop-eks/terraform.tfstate"
    //dynamodb_table = "app-table"
  }

  required_version = "~> 1.3"
}
