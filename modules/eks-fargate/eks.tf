resource "aws_eks_cluster" "cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids = aws_subnet.private_subnets[*].id
  }
  depends_on = [
    aws_iam_role_policy_attachment.demo-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.demo-AmazonEKSVPCResourceController,
  ]
}

resource "aws_eks_fargate_profile" "fg_profile" {
  cluster_name           = aws_eks_cluster.cluster.name
  fargate_profile_name   = var.fargate_profile_name
  pod_execution_role_arn = aws_iam_role.fg_role.arn
  subnet_ids             = aws_subnet.private_subnets[*].id

  selector {
    namespace = "demo"
  }
}