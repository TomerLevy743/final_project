

resource "aws_iam_policy" "ebs_csi_policy" {
  name        = "AmazonEKS_EBS_CSI_Driver_Policy_tomer_guy"
  description = "Policy for EBS CSI driver to manage EBS volumes"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:CreateSnapshot",
          "ec2:AttachVolume",
          "ec2:DetachVolume",
          "ec2:ModifyVolume",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeInstances",
          "ec2:DescribeSnapshots",
          "ec2:DescribeTags",
          "ec2:DescribeVolumes",
          "ec2:DescribeVolumesModifications"
        ]
        Resource = "arn:aws:ec2:*:*:volume/*"
      },
      {
        Effect = "Allow"
        Action = [
          "ec2:CreateTags"
        ]
        Resource = "arn:aws:ec2:*:*:volume/*"
        Condition = {
          "StringEquals" = {
            "ec2:CreateAction" = "CreateVolume"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role" "ebs_csi_role" {
  name = "AmazonEKS_EBS_CSI_Driver_Role_tomer_guy"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = var.oidc_arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          "StringEquals" = {
            "oidc.eks.${var.region}.amazonaws.com/id/${var.oidc_id}:sub" = "system:serviceaccount:kube-system:ebs-csi-controller"
          }
        }
      }
    ]
  })
}
resource "aws_iam_policy_attachment" "ebs_csi_attach" {
  name       = "ebs-csi-attachment"
  policy_arn = aws_iam_policy.ebs_csi_policy.arn
  roles      = [aws_iam_role.ebs_csi_role.name]
}
resource "aws_eks_addon" "ebs_csi" {
  cluster_name             = var.clusterName
  addon_name               = "aws-ebs-csi-driver"
  service_account_role_arn = aws_iam_role.ebs_csi_role.arn
}
