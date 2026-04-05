terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 6.0"
        }
    }
}

variable "region" {
    type = string
    default = "us-east-1"
    description = "The AWS Region to connect and run the tests in."
}

provider "aws" {
    region = var.region
}
 