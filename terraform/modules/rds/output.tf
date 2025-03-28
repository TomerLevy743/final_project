output "rds_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = join("", regex("([^:]+)", aws_db_instance.statuspage_db.endpoint))
}
