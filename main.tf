provider "aws" {
  region = local.region
}

### Locals ###

data "aws_caller_identity" "current" {}

locals {
  account_id   = data.aws_caller_identity.current.account_id
  region       = "sa-east-1"
  project_name = "macie-sandbox"
}

### S3 ###

# Source

resource "aws_s3_bucket" "main" {
  bucket = "${local.project_name}-${local.region}-epomatti"

  tags = {
    Name = "Sandbox Bucket"
  }
}

resource "aws_s3_bucket_acl" "main" {
  bucket = aws_s3_bucket.main.id
  acl    = "private"
}

resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "secrets_json" {
  bucket = aws_s3_bucket.main.id
  key    = "secrets.txt"
  source = "./secrets.txt"
  etag   = filemd5("./secrets.txt")
}

### Macie ###

resource "aws_macie2_account" "test" {
  status = "ENABLED"
}

output "account_id" {
  value = local.account_id
}

output "s3" {
  value = aws_s3_bucket_acl.main.bucket
}
