output "lb-sg" {
  description = "The ID of the load balancer group"
  value       = aws_security_group.elb-sg.id
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
