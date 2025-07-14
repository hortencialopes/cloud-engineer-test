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
      data.terraform_remote_state.networking.outputs.networking_output.public_subnet_az1_id,
      data.terraform_remote_state.networking.outputs.networking_output.public_subnet_az2_id,
      data.terraform_remote_state.networking.outputs.networking_output.private_subnet_az1_id,
      data.terraform_remote_state.networking.outputs.networking_output.private_subnet_az2_id
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
    data.terraform_remote_state.networking.outputs.networking_output.private_subnet_az1_id,
    data.terraform_remote_state.networking.outputs.networking_output.private_subnet_az2_id
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

data "aws_eks_cluster_auth" "cluster" {
  name = var.cluster_name
}

#My pipeline needs to interact with the cluster so adding provider to interact with the EKS cluster
provider "kubernetes" {
  host                   = aws_eks_cluster.eks_cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks_cluster.certificate_authority[0].data)

  token = data.aws_eks_cluster_auth.cluster.token
  # This uses the credentials of the identity running Terraform to get a token
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.eks_cluster.name]
    command     = "aws"
  }
}

# This resource will manage the aws-auth ConfigMap within Kubernetes
resource "kubernetes_config_map_v1" "aws_auth" {
  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    
    mapRoles = yamlencode([
      {
        rolearn  = aws_iam_role.nodes.arn
        username = "system:node:{{EC2PrivateDNSName}}"
        groups   = [
          "system:bootstrappers",
          "system:nodes",
        ]
      },
      # This new entry grants my CodeBuild role permissions within the cluster.
      {
        rolearn  = aws_iam_role.codebuild.arn
        username = "codebuild-service-role" 
        groups = [
          "system:masters" 
        ]
      }
    ])

    mapUsers = yamlencode(
      [for user_arn in var.admin_user_arns : {
        userarn  = user_arn
        username = split("/", user_arn)[1]
        groups   = [
          "system:masters"
        ]
      }]
    )
  }

  # This ensures that the ConfigMap is updated only after the roles are created.
  depends_on = [
    aws_iam_role.nodes,
    aws_iam_role.codebuild,
  ]
}