terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    token                  = module.eks.cluster_token
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  }
}

provider "aws" {
  region = var.region
}
