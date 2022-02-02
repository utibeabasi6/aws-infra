output "ec2_ip" {
  value = aws_instance.lamp-server[0].public_ip
  description = "The IP address of the LAMP server"
}