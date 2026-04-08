data "aws_iam_policy_document" "instance_assume_role_policy" {
    statement {
        actions = ["sts:AssumeRole"]
        principals {
            type = "Service"
            identifiers = ["ec2.amazonaws.com"]
        }
    }
}

resource "aws_iam_role" "main" {
    name = "${var.name_prefix}-instance-role"
    assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json
}

resource "aws_iam_instance_profile" "main" {
    name = aws_iam_role.main.name
    role = aws_iam_role.main.name
}

data "aws_iam_policy" "ssm_arn" {
    arn = "arn:aws:iam::aws:policy/AmazonSSMManagedEC2InstanceDefaultPolicy"
}

variable "enable_systems_manager" {
    type = bool
    description = "When enabled the Systems Manager IAM Policy will be attached to the instance."
    default = false
}

resource "aws_iam_role_policy_attachment" "ssm_attach" {
    count = var.enable_systems_manager ? 1 : 0
    role = aws_iam_role.main.name
    policy_arn = data.aws_iam_policy.ssm_arn.arn
}
 
resource "aws_instance" "hello_world" {
    ami = var.ami
    subnet_id = var.subnet_id
    instance_type = var.instance_type
    tags = merge(var.tags, {
        Name = "${var.name_prefix}-instance"
    })
    count = var.instance_count
    iam_instance_profile = aws_iam_instance_profile.main.name
}
