resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }

  tags = {
    # Owner = "tomerlevy",
    Owner = "guytamari"
  }

  depends_on = [
    # aws_iam_role_policy_attachment.this,
    aws_iam_role_policy_attachment.eks_cluster_policy,
    var.vpc_id
  ]
}

resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "eks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role" "eks_node_group_role" {
  name = "eks-node-group-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  role       = aws_iam_role.eks_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "ecr_read_only" {
  role       = aws_iam_role.eks_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.eks_node_group_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_eks_node_group" "eks_nodes" {
  cluster_name    = var.cluster_name
  node_group_name = "eks-node-group"
  node_role_arn   = aws_iam_role.eks_node_group_role.arn
  subnet_ids      = var.subnet_ids
  instance_types  = ["t3.medium"] # Choose instance type

  scaling_config {
    desired_size = 2 # Adjust as needed
    max_size     = 4
    min_size     = 2
  }

  remote_access {
    ec2_ssh_key = "GuyTamari-KeyPair" # Optional, for SSH access
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_eks_cluster.this
  ]
}


resource "aws_iam_role" "eks_user_role" {
  name = "eks-user-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::992382545251:user/guytamari" # ARN of the first user
        }
        Action = "sts:AssumeRole"
      },
      {
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::992382545251:user/tomerlevy" # ARN of the second user
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_user_role_policy" {
  role       = aws_iam_role.eks_user_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "kubernetes_config_map" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = <<-EOT
      - rolearn: arn:aws:iam::992382545251:role/guytamari-role
        username: guytamari
        groups:
          - system:masters  # Granting admin access, modify as needed
      - rolearn: arn:aws:iam::992382545251:role/tomerlevy-role
        username: tomerlevy
        groups:
          - system:masters  # Granting admin access, modify as needed
    EOT
  }

}
