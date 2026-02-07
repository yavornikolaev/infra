module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  addons = {
    coredns = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
    }
  }

  name               = var.name
  kubernetes_version = var.kubernetes_version

  endpoint_public_access                   = var.endpoint_public_access
  enable_cluster_creator_admin_permissions = var.enable_cluster_creator_admin_permissions


  create_kms_key                  = false
  attach_encryption_policy        = false
  encryption_config               = null
  cloudwatch_log_group_kms_key_id = null

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  eks_managed_node_groups = var.eks_managed_node_groups

  cluster_tags = var.tags
  tags         = var.tags
}