resource "aws_instance" "ec2" {

  count = var.instance_count  
  ami   = local.ami_id
  instance_type = var.instance_type
  iam_instance_profile = var.instance_profile_name
  key_name = var.key_name
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  associate_public_ip_address = var.associate_public_ip
  
  user_data = var.user_data

  root_block_device {
    volume_size           = var.root_volume_size
    delete_on_termination = true
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.name_prefix}-${count.index + 1}"
    }
  )
}