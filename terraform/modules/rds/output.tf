output "rds_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = join("", regex("([^:]+)", aws_db_instance.statuspage_db.endpoint))
  # value       = join("", regex("([^:]+)", aws_db_instance.statuspage_db.endpoint))
}
output "db_name" {
  description = "The name of the database"
  value       = aws_db_instance.statuspage_db.db_name
}
output "db_user" {
  description = "The username for the database"
  value       = aws_db_instance.statuspage_db.username
}
output "db_password" {
  description = "The password for the database"
  value       = aws_db_instance.statuspage_db.password
}
