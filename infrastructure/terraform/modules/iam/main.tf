data "tls_certificate" "eks" {
  url = var.oidc_issuer_url
}

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = [
    data.tls_certificate.eks.certificates[0].sha1_fingerprint
  ]

  url = var.oidc_issuer_url
}

resource "aws_iam_policy" "aws_load_balancer_controller" {
  name = "${var.cluster_name}-aws-load-balancer-controller"

  policy = file("${path.module}/policies/aws-load-balancer-controller-policy.json")
}

locals {
  oidc_provider_url = replace(var.oidc_issuer_url, "https://", "")
}

resource "aws_iam_role" "aws_load_balancer_controller" {
  name = "${var.cluster_name}-aws-load-balancer-controller-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRoleWithWebIdentity"
        Principal = {
          Federated = aws_iam_openid_connect_provider.eks.arn
        }
        Condition = {
          StringEquals = {
            "${local.oidc_provider_url}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
            "${local.oidc_provider_url}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "aws_load_balancer_controller" {
  role       = aws_iam_role.aws_load_balancer_controller.name
  policy_arn = aws_iam_policy.aws_load_balancer_controller.arn
}

resource "aws_iam_policy" "backend_secrets_read" {
  name = "${var.cluster_name}-backend-secrets-read"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue"
        ]
        Resource = var.rds_secret_arn
      }
    ]
  })
}

resource "aws_iam_role" "backend_pod" {
  name = "${var.cluster_name}-backend-pod-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "pods.eks.amazonaws.com"
        }
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "backend_secrets_read" {
  role       = aws_iam_role.backend_pod.name
  policy_arn = aws_iam_policy.backend_secrets_read.arn
}