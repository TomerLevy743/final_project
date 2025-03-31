variable "vpc_cidr" {
  description = "CIDR range for the VPC"
  type        = string
}

variable "availability_zones" {
  description = "The availability zone to deploy"
  type        = list(string)
}

variable "owner" {
  description = "Owner tag for the security groups"
  type        = string
  default     = "tomerlevy"
}
variable "naming" {
  description = "the naming of the resources"
  type        = string
}
