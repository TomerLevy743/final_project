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


variable "subnet_ids" {
  description = "List of subnet IDs for the RDS subnet group"
  type        = list(string)
}


variable "database-sg" {
  description = "database sg"
  type        = string
}
variable "owner" {
  description = "owner tag"
  type        = string
}

