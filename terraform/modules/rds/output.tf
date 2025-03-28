output "rds_endpoint" {
  description = "The endpoint of the RDS instance"
  value       = join("", regex("([^:]+)", module.rds.db_instance_endpoint))
  # value       = join("", regex("([^:]+)", aws_db_instance.statuspage_db.endpoint))
}
