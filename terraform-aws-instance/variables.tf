variable "ami" {
    type = string
    description = "AMI to launch EC2 instance."
}

variable "subnet_id" {
    type = string
    description = "subnet id to launch EC2 instance in."
}

variable "instance_type" {
    type = string
    description = "type of compute instance."
    default = "t3.micro"
}