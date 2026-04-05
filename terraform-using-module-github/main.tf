provider "aws" {
  region = "us-east-1"
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values =[data.aws_vpc.default.id]
  }
}

data "aws_ami" "ubuntu" {
  owners      =["099720109477"] # Canonical
  most_recent = true

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "name"
    values =["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
}

module "my_github_ec2" {
  source = "git::https://github.com/LowTechTurtle/Terraform-in-depth.git//terraform-aws-instance?ref=main"

  ami           = data.aws_ami.ubuntu.id
  subnet_id     = data.aws_subnets.default.ids[0]
    instance_type = "t3.micro" 
}

output "new_instance_arn" {
  description = "The ARN of the EC2 instance built from my GitHub module."
  value       = module.my_github_ec2.aws_instance_arn
}
