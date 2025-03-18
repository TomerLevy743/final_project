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

variable "public_subnet_cidr" {
  description = "CIDR range for the public subnets"
  type        = list(string)
  default     = ["10.1.1.0/24", "10.1.2.0/24"]
}

variable "private_subnet_cidr" {
  description = "CIDR range for the private subnet"
  type        = list(string)
  default     = ["10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24"]
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
  default     = "tomerlevy"
}
