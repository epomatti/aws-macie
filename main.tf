terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.region
}

### Locals ###
data "aws_caller_identity" "current" {}

locals {
  account_id   = data.aws_caller_identity.current.account_id
  project_name = "macie-sandbox"
}

### S3 ###
# Source
resource "aws_s3_bucket" "main" {
  bucket = "${local.project_name}-${var.region}-epomatti"

  tags = {
    Name = "Sandbox Bucket"
  }
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
