output "jenkins_public_ip" {
  value = aws_instance.jenkins.public_ip
}

output "ssh_user" {
  value = "ec2-user"
}

output "ssh_private_key_path" {
  value = pathexpand("~/.ssh/aws_key.pem")
}
