/*
where the magic happens
https://developer.hashicorp.com/terraform/tutorials/kubernetes/eks
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster
*/


resource "aws_eks_cluster" "eks_cluster" {
  name     = var.cluster_name
  role_arn = aws_iam_role.cluster.arn
  version  = var.cluster_version

  vpc_config {
    subnet_ids = [
      data.terraform_remote_state.network.outputs.public_subnet_az1_id,
      data.terraform_remote_state.network.outputs.public_subnet_az2_id,
      data.terraform_remote_state.network.outputs.private_subnet_az1_id,
      data.terraform_remote_state.network.outputs.private_subnet_az2_id
    ]
    # This ensures that the ALB created by the AWS Load Balancer Controller
    # can communicate with the cluster.
    public_access_cidrs = ["0.0.0.0/0"]
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_amazon_eks_cluster_policy,
  ]
  tags = var.tags

}

data "aws_availability_zones" "availability_zones" {}

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = var.node_group_name
  node_role_arn   = aws_iam_role.nodes.arn

  subnet_ids = [
    data.terraform_remote_state.network.outputs.private_subnet_az1_id,
    data.terraform_remote_state.network.outputs.private_subnet_az2_id
  ]

  instance_types = var.node_group_instance_types
  capacity_type  = var.node_group_capacity_type
  ami_type       = var.node_group_ami_type

  scaling_config {
    desired_size = var.node_group_desired_size
    max_size     = var.node_group_max_size
    min_size     = var.node_group_min_size
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.nodes_policies,
  ]

  tags = var.tags
}
