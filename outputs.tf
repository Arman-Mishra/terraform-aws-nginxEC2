output "instance_public_id_1" {
  value = aws_instance.vm_1.public_ip
}

output "ubuntu_ami_id" {
  value = data.aws_ami.ubuntu.id
}