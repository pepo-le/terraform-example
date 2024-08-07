output "private_ip" {
  value = aws_instance.main.private_ip
}

output "public_ip" {
  value = aws_instance.main.public_ip
}

output "eip" {
  value = aws_eip.main[0].public_ip
}

output "instance_id" {
  value = aws_instance.main.id
}
