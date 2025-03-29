data "tls_certificate" "eks" {
  url = var.eks_url
}

resource "aws_iam_role" "eks_ebs_csi_driver" {
  assume_role_policy = data.aws_iam_policy_document.eks_csi_assume_role_policy.json
  name               = "eks-ebs-csi-driver"
}

data "aws_iam_policy_document" "eks_csi_assume_role_policy" {
  statement {
    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]
    effect = "Allow"
    condition {
      test     = "StringEquals"
      variable = "${var.eks_arn}:sub"
      values   = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
    }
    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::992382545251:oidc-provider/${var.eks_arn}"]
    }
  }
}

resource "aws_iam_policy" "eks_csi_driver_policy" {
  name        = "eks-csi-driver-policy"
  description = "Policy for EKS CSI driver to interact with EBS"

  policy = data.aws_iam_policy_document.eks_csi_driver_policy.json
}

data "aws_iam_policy_document" "eks_csi_driver_policy" {
  statement {
    actions = [
      "ec2:DescribeVolumes",
      "ec2:DescribeSnapshots",
      "ec2:CreateVolume",
      "ec2:DeleteVolume",
      "ec2:AttachVolume",
      "ec2:DetachVolume",
      "ec2:CreateTags",
      "ec2:DescribeInstances"
    ]
    resources = ["*"]
  }
}


resource "aws_iam_role_policy_attachment" "amazon_ebs_csi_driver" {
  role       = aws_iam_role.eks_ebs_csi_driver.name
  policy_arn = aws_iam_policy.eks_csi_driver_policy.arn
}
