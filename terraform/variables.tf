variable "region" {
  description = "AWS region to deploy"
  type        = string
  default     = "us-east-1"
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
  default     = "guytamari"
}


variable "route53_name" {
  description = "name of the dns"
  type = string
  default = "status-page.org"
}

variable "route53_zoneID" {
  description = "zone id"
  type = string
  default = "Z04520012OG00EVC9GKI3"
}