output "account_id" {
  value = local.account_id
}

output "s3" {
  value = aws_s3_bucket.main.bucket
}
