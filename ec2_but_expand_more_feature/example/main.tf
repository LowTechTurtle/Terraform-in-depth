data "aws_vpc" "default" {
    default = true
}

data "aws_subnets" "default" {
    filter {
        name = "vpc-id"
        values = [data.aws_vpc.default.id]
    }
}

data "aws_ami" "ubuntu" {
    owners = ["099720109477"]
    most_recent = true

    filter {
      name = "virtualization-type"
      values = [ "hvm" ]
    }

    filter {
      name = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }
}

module "test_instance" {
    source  = "../"
    subnet_id = data.aws_subnets.default.ids[0]
    ami = data.aws_ami.ubuntu.id  # CORRECT
}

output "aws_instance_arn" {
    value = module.test_instance.aws_instance_arn
}