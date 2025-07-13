/**
We need to create two iam roles, one for the cluster and another for the node group

jsonencode helps me with the policies!
*/

resource "aws_iam_role" "cluster" {

  for_each = toset(var.cluster_name)
  name     = "${each.key}-cluster-role"

  #name = "${var.project_name}-${var.cluster_name}-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ] 
      },
    ]
  })

}

##attatching to cluster role

resource "aws_iam_role_policy_attachment" "cluster_amazon_eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

resource "aws_iam_role" "nodes" {

  for_each = toset(var.cluster_name)
  name     = "${each.key}-nodes-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
    ]
  })

}

### now the worker nodes managed necessary policies
resource "aws_iam_role_policy_attachment" "nodes_policies" {
  # for_each creates an instance of this resource for each item in the set.
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  ])

  policy_arn = each.key
  role       = aws_iam_role.nodes.name
}

