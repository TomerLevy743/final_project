output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_azs_id" {
  description = "The ID of the public subnet az1"
  value       = aws_subnet.public_azs.id
}



output "private_subnet_id" {
  description = "The ID of the private subnet"
  value       = aws_subnet.private.id
}
