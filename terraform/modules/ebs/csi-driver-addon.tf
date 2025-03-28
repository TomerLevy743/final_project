resource "aws_eks_addon" "csi_driver" {
  cluster_name             = var.cluster_name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = "v1.41.0-eksbuild.1"
  service_account_role_arn = aws_iam_role.eks_ebs_csi_driver.arn
  depends_on = [
    aws_iam_role.eks_ebs_csi_driver,
    aws_iam_role_policy_attachment.amazon_ebs_csi_driver,
  ]
}

