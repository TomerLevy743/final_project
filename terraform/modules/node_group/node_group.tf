
module "eks_node_group" {
  source  = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"
  version = "19.21.0"

  cluster_name = var.cluster_name
  subnet_ids   = var.subnet_ids

  cluster_primary_security_group_id = var.cluster_security_group_id
  # module.eks.cluster_primary_security_group_id
  vpc_security_group_ids = [var.cluster_nodes_security_group_id]

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




resource "aws_iam_policy" "ebs_csi_permissions" {
  name        = "ebs-csi-permissions"
  description = "Policy to allow EBS CSI driver to create and manage unencrypted EBS volumes"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:CreateVolume",
          "ec2:DescribeVolumes",
          "ec2:AttachVolume",
          "ec2:DeleteVolume",
          "ec2:ModifyVolume"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ebs_csi_policy_attachment" {
  role       = module.eks_node_group.iam_role_name
  policy_arn = aws_iam_policy.ebs_csi_permissions.arn
}
