module "network" {
  source = "../../modules/network"

  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "eks" {
  source = "../../modules/eks"

  cluster_name       = var.cluster_name
  node_desired_size  = var.node_desired_size
  node_min_size      = var.node_min_size
  node_max_size      = var.node_max_size
  cluster_version    = var.cluster_version
  private_subnet_ids = module.network.private_subnet_ids
  node_instance_type = var.node_instance_type
}

module "ecr" {
  source = "../../modules/ecr"

  ecr_repository_name = var.ecr_repository_name
}

module "iam" {
  source = "../../modules/iam"

  cluster_name    = var.cluster_name
  oidc_issuer_url = module.eks.oidc_issuer_url
}