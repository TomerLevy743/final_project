resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }

  tags = {
    Owner = var.owner
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    var.vpc_id
  ]
}

resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role-tomer-guy"

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
  name = "tomer-guy-eks-node-group-role"

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
  
  tags = {
    Name  = "tomer-guy-eks-node"
    Owner = var.owner # Ensure `var.owner` is defined in your variables
  }
  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_eks_cluster.this
  ]
}


resource "aws_iam_role" "eks_user_role" {
  name = "eks-user-role-tomer-guy"

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
      - rolearn: arn:aws:iam::992382545251:role/tomer-guy-eks-node-group-role
        username: tomer-guy-node
        groups:
          - system:bootstrappers
          - system:nodes
      - rolearn: arn:aws:iam::992382545251:role/guytamari-role
        username: guytamari
        groups:
          - system:masters
      - rolearn: arn:aws:iam::992382545251:role/tomerlevy-role
        username: tomerlevy
        groups:
          - system:masters
    EOT
  }
}


data "aws_autoscaling_groups" "eks_asg" {
  filter {
    name   = "tag:eks:nodegroup-name"
    values = [var.node_group_name]
  }
  depends_on = [aws_eks_node_group.eks_nodes]
}

resource "aws_autoscaling_group_tag" "eks_tags" {
  for_each = {
    "Name"  = "tomer-guy-eks-node"
    "Owner" = var.owner

  }

  autoscaling_group_name = tolist(data.aws_autoscaling_groups.eks_asg.names)[0]
  tag {
    key                 = each.key
    value               = each.value
    propagate_at_launch = true
  }
}
resource "aws_iam_role" "asg_role" {
  name = "asg_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "autoscaling.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "asg_tagging_policy" {
  name        = "ASGTaggingPolicy"
  description = "Policy to allow ASG to apply tags to instances"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "autoscaling:CreateOrUpdateTags",
          "ec2:CreateTags",
          "ec2:DescribeInstances",
          "ec2:ModifyInstanceAttribute"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_asg_tagging_policy" {
  role       = aws_iam_role.asg_role.name
  policy_arn = aws_iam_policy.asg_tagging_policy.arn
}