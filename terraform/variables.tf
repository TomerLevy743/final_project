variable "region" {
  description = "AWS region to deploy"
  type        = string
}
variable "availability_zones" {
  description = "The availability zone to deploy"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "vpc_cidr" {
  description = "CIDR range for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "from_port" {
  description = "from port"
  type        = list(number)
  default     = [80, 443, 22]
}
variable "to_port" {
  description = "to port"
  type        = list(number)
  default     = [80, 443, 22]
}
variable "owner" {
  description = "Owner tag for the resources"
  type        = string
}

variable "naming" {
  description = "the naming of the resources"
  type        = string
}

variable "route53_name" {
  description = "name of the dns"
  type        = string
}

variable "route53_zoneID" {
  description = "zone id"
  type        = string
}
variable "secert_key" {
  description = "the secret key"
  type        = string
}
variable "superuser_name" {
  description = "the superuser name"
  type        = string
}
variable "superuser_password" {
  description = "the superuser password"
  type        = string
}
variable "superuser_email" {
  description = "the superuser email"
  type        = string
}
variable "image_repository_statuspage" {
  description = "the image repository"
  type        = string
}
variable "image_repository_nginx" {
  description = "the image repository"
  type        = string
}

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
