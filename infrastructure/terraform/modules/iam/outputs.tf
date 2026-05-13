output "backend_pod_role_arn" {
  value = aws_iam_role.backend_pod.arn
}

output "jenkins_pod_role_arn" {
  value = aws_iam_role.jenkins_pod.arn
}

output "ebs_csi_driver_role_arn" {
  value = aws_iam_role.ebs_csi_driver.arn
}