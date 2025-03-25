

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
        Resource = "*"
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
      },
      {
        Effect = "Allow"
        Action = [
          "sts:AssumeRoleWithWebIdentity"
        ]
        Resource = "*"
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
          Federated = "arn:aws:iam::992382545251:oidc-provider/oidc.eks.${var.region}.amazonaws.com/id/${var.oidc_id}"
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          "StringEquals" = {
            "oidc.eks.${var.region}.amazonaws.com/id/${var.oidc_id}:sub" = "system:serviceaccount:kube-system:ebs-csi-controller-sa"
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
resource "helm_release" "ebs_csi_driver" {
  name       = "ebs-csi-driver"
  namespace  = "kube-system"
  repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver/"
  chart      = "aws-ebs-csi-driver"
  version    = "2.41.0"  

  values = [
    <<EOF
    controller:
      replicaCount: 1
    EOF
  ]

  set {
    name  = "controller.serviceAccount.create"
    value = "false"
  }

  set {
    name  = "controller.serviceAccount.name"
    value = "ebs-csi-controller-sa"
  }

  depends_on = [aws_iam_policy_attachment.ebs_csi_attach]
}
