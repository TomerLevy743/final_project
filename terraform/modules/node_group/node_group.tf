
module "eks_node_group" {
  source  = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"
  version = "19.21.0"

  cluster_name = var.cluster_name
  subnet_ids   = var.subnet_ids

  instance_types = ["t3.medium"]
  desired_size   = 2
  min_size       = 1
  max_size       = 3

  capacity_type = "ON_DEMAND"
  name          = var.node_group_name
  tags = {
    Name  = "eks_worker_nodes_tg"
    Owner = var.owner
  }
  # depends_on = [module.eks.eks_cluster]
}
