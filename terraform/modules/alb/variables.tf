variable "eks_arn" {
  description = "The ARN of the OpenID Connect provider"
  type        = string
}

variable "vpc_id" {
  description = "vpc id"
  type        = string

}
variable "cluster_name" {
  description = "cluster name"
  type        = string
}
