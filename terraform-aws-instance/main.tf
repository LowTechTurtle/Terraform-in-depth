resource "aws_instance" "hello_world" {
    ami = var.ami
    subnet_id = var.subnet_id
    instance_type = var.instance_type
}
