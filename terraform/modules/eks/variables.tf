variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "tomer-guy-statuspage-cluster"
}
variable "cluster_version" {
  description = "The version of the EKS cluster"
  type        = string
  default     = "1.31"
}
variable "cluster_public_access" {
  description = "cluster endpoint public access"
  type        = bool
  default     = true
}
variable "enable_cluster_creator_admin_permissions" {
  description = "Adds the current caller identity as an administrator via cluster access entry"
  type        = bool
  default     = true
}
variable "vpc_id" {
  description = "The ID of the VPC where the cluster will be created"
  type        = string
}
variable "subnet_ids" {
  description = "The IDs of the subnets where the nodes will be created"
  type        = list(string)
}
variable "security_group_ids" {
  description = "The IDs of the security groups that will be attached to the EKS cluster"
  type        = list(string)
}
# variable "security_group_frontend" {
#   description = "The ID of the frontend security group"
#   type        = string
# }
# variable "security_group_backend" {
#   description = "The ID of the backend security group"
#   type        = string
# }
# variable "security_group_database" {
#   description = "The ID of the database security group"
#   type        = string

# }
