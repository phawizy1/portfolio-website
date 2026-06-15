terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "portfolio" {
  bucket = var.bucket_name
  tags = {
    Name = "Portfolio Website"
  }
}

resource "aws_s3_bucket_public_access_block" "portfolio" {
  bucket = aws_s3_bucket.portfolio.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "portfolio" {
  bucket = aws_s3_bucket.portfolio.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid    = "PublicRead"
      Effect = "Allow"
      Principal = "*"
      Action = "s3:GetObject"
      Resource = "${aws_s3_bucket.portfolio.arn}/*"
    }]
  })
  depends_on = [aws_s3_bucket_public_access_block.portfolio]
}

resource "aws_s3_bucket_website_configuration" "portfolio" {
  bucket = aws_s3_bucket.portfolio.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "index.html"
  }
}

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.portfolio.id
  key          = "index.html"
  source       = "./index.html"
  etag         = filemd5("./index.html")
  content_type = "text/html"
}

resource "aws_s3_object" "readme" {
  bucket       = aws_s3_bucket.portfolio.id
  key          = "README.md"
  source       = "./README.md"
  etag         = filemd5("./README.md")
  content_type = "text/markdown"
}
