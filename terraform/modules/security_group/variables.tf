variable "vpc_id" {
  description = "The ID of the VPC where the security groups will be created"
  type        = string
}

variable "owner" {
  description = "Owner tag for the security groups"
  type        = string
}

variable "from_port" {
  description = "from port"
  type        = list(number)
}
variable "to_port" {
  description = "to port"
  type        = list(number)
}
variable "eks_default_sg" {
  description = "The default security group for EKS"
  type        = string
}
variable "naming" {
  description = "the naming of the resources"
  type        = string
}
