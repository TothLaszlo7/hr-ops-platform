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
  rds_secret_arn  = module.rds.master_user_secret_arn
}

module "rds" {
  source = "../../modules/rds"

  db_name            = var.db_name
  db_username        = var.db_username
  private_subnet_ids = module.network.private_subnet_ids
  vpc_id             = module.network.vpc_id
}

resource "aws_eks_pod_identity_association" "backend" {
  cluster_name    = var.cluster_name
  namespace       = "hr-ops"
  service_account = "backend-sa"
  role_arn        = module.iam.backend_pod_role_arn

  depends_on = [
    module.eks
  ]
}

resource "aws_eks_pod_identity_association" "jenkins" {
  cluster_name    = var.cluster_name
  namespace       = "jenkins"
  service_account = "jenkins"
  role_arn        = module.iam.jenkins_pod_role_arn

  depends_on = [
    module.eks
  ]
}