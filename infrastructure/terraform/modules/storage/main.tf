resource "aws_s3_bucket" "reports" {
  bucket = "${var.project_name}-reports-${random_string.suffix.result}"

  tags = {
    Name = "${var.project_name}-reports"
  }
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}