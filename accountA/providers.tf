terraform {
  required_version = "~> 1.1.2"

  required_providers {
    aws = {
      version = "~> 4.12.1"
      source  = "hashicorp/aws"
    }
  }
}

# Download AWS provider
provider "aws" {
  region = "us-east-2"
  default_tags {
    tags = {
      Owner = "Playground Scenario 4"
      Admin = "Kyler"
    }
  }
}
