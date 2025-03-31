variable "db_username" {
  description = "The username for the PostgreSQL database"
  type        = string
}

variable "db_password" {
  description = "The password for the PostgreSQL database"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "The name of the PostgreSQL database"
  type        = string
}


variable "subnet_ids" {
  description = "List of subnet IDs for the RDS subnet group"
  type        = list(string)
}


variable "database-sg" {
  description = "database security group"
  type        = string
}
variable "owner" {
  description = "owner tag"
  type        = string
}
variable "naming" {
  description = "the naming of the resources"
  type        = string
}
