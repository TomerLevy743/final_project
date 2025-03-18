variable "vpc_id" {
  description = "The ID of the VPC where the security groups will be created"
  type        = string
}

variable "owner" {
  description = "Owner tag for the security groups"
  type        = string
  default     = "tomerlevy"
}

variable "private_subnet_cidr" {
  description = "private subnet cidr"
  type        = list(string)
}
variable "from_port" {
  description = "from port"
  type        = list(number)
}
variable "to_port" {
  description = "to port"
  type        = list(number)
}
