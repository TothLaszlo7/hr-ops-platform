output "reports_bucket_arn" {
  value = aws_s3_bucket.reports.arn
}

output "reports_bucket_name" {
  value = aws_s3_bucket.reports.bucket
}