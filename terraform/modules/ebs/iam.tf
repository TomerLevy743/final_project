data "tls_certificate" "eks" {
  url = var.eks_url
}

# resource "aws_iam_openid_connect_provider" "eks" {
#   client_id_list  = ["sts.amazonaws.com"]
#   thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
#   url             = var.eks_url
#   # lifecycle {
#   #   ignore_changes = [var.eks_url] # Ignore changes to the URL field if the provider already exists
#   # }
# }



# output "oidc_arn" {
#   value = data.aws_iam_openid_connect_provider.eks.arn
# }

# output "oidc_id" {
#   value = data.aws_iam_openid_connect_provider.eks.id
# }


# Step 3: Construct the OIDC Provider ARN

# data "aws_iam_policy_document" "csi" {
#   statement {
#     actions = ["sts:AssumeRoleWithWebIdentity"]
#     effect  = "Allow"

#     condition {
#       test     = "StringEquals"
#       variable = "${replace(var.eks_url, "https://", "")}:sub"
#       values   = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
#     }

#     principals {
#       identifiers = [var.eks_arn]
#       type        = "Federated"
#     }
#   }
# }

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
      variable = "oidc.eks.us-east-1.amazonaws.com/id/${var.eks_id}:sub"
      values   = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
    }
    principals {
      type        = "Federated"
      identifiers = [var.eks_arn]
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
