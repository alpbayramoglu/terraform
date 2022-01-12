output "pub_ip" {
  value = aws_instance.izmir[*].public_ip
}
output "prv_ip" {
  value = aws_instance.izmir.*.private_ip
}
