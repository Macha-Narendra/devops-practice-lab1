terraform {
  backend "s3" {
    bucket         = "narendra-eks-terraform-state-123"
    key            = "dev/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
