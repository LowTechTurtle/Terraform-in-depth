output "aws_instance_arn" {
    value = aws_instance.hello_world.arn
}

output "aws_instance_ip" {
    value = aws_instance.hello_world.private_ip
}

output "aws_instance" {
    description = "The entire instance resource."
    value = aws_instance.hello_world
}

output "aws_instance_role" {
    value = aws_iam_role.main
}