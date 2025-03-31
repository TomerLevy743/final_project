variable "eks_arn" {
  description = "The ARN of the OpenID Connect provider"
  type        = string
}

variable "vpc_id" {
  description = "vpc id"
  type        = string

}
variable "naming" {
  description = "the naming of the resources"
  type        = string
}
