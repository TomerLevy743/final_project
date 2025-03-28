variable "owner" {
  description = "The user name of the cluster owner tag"
  type        = string
}
variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "tomer-guy-statuspage-cluster"
}
variable "node_group_name" {
  description = "value of the node group name"
  type        = string
  default     = "eks-node-group-tg"
}
variable "subnet_ids" {
  description = "The IDs of the subnets where the nodes will be created"
  type        = list(string)
}
