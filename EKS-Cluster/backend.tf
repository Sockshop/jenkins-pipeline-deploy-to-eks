terraform {
  backend "s3" {
    bucket = "sockshop-project-backend"
    region = "eu-west-3"
    key    = "eks/terraform.tfstate"
    //dynamodb_table = "app-table"
  }
}

