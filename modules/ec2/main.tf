resource "aws_instance" "ec2" {
  count         = var.instance_count  
  ami           = var.ami_id
  instance_type = var.instance_type
  iam_instance_profile = var.instance_profile_name
  key_name = var.key_name
  associate_public_ip_address = var.associate_public_ip

  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  
  user_data = var.user_data

  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = var.root_volume_type
    delete_on_termination = true
  }

  tags = merge(
    {
      Name = "${var.name_prefix}-${count.index + 1}"
    },
    var.tags
  )
}
