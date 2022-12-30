#------main.tf------#
#All done in AWS Cloud9

#AWS Provider from Terraform Registry
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

#AWS provider with default region
provider "aws" {
  region  = "us-east-1"
}

#Key Pair for resources----come back later
resource "aws_key_pair" "" {        
  key_name   = ""
  public_key = ""
}

#Default VPC for resources----come back later
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

