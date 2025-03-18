variable "vpc_cidr" {
  description = "CIDR range for the VPC"
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR range for the private subnet"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR range for the public subnet"
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