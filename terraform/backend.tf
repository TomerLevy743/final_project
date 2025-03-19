terraform {
  backend "s3" {
    bucket  = "guy-tomer-tfstate" # Replace with your S3 bucket name
    key     = "terraform.tfstate" # Path where the state file will be stored
    encrypt = true
    region  = "us-east-1"
  }
}
