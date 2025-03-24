variable "db_username" {
  description = "The username for the PostgreSQL database"
  type        = string
  default     = "admin_statuspage"
}

variable "db_password" {
  description = "The password for the PostgreSQL database"
  type        = string
  sensitive   = true
  default     = "0123456789"
}

variable "db_name" {
  description = "The name of the PostgreSQL database"
  type        = string
  default     = "db_statuspage"
}
