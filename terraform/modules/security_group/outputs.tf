output "lb-sg" {
  description = "The ID of the load balancer group"
  value       = aws_security_group.elb_sg.id
}
output "frontend-sg" {
  description = "The ID of the frontend group"
  value       = aws_security_group.frontend-sg.id
}

output "backend-sg" {
  description = "The ID of the backend group"
  value       = aws_security_group.backend-sg.id
}
output "database-sg" {
  description = "The ID of the database group"
  value       = aws_security_group.database-sg.id
}

# output "eks_security_group_id" {
#   description = "The ID of the eks security group"
#   # database-sg = 0, backend-sg = 1, frontend-sg = 2, lb-sg = 3
#   value = [database-sg, backend-sg, frontend-sg, lb-sg]
# }
