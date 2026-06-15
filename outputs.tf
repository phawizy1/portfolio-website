output "bucket_name" {
  value = aws_s3_bucket.portfolio.id
}

output "website_url" {
  value = "http://${aws_s3_bucket_website_configuration.portfolio.website_endpoint}"
}
