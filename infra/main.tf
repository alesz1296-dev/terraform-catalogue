resource "aws_s3_bucket" "catalogue" {
  bucket = "terraform-catalogue-static-site-asa001"
}

resource "aws_s3_bucket_versioning" "catalogue" {
  bucket = aws_s3_bucket.catalogue.id

  versioning_configuration {
    status = "Enabled"
  }
}

#block public access, users should access the S3 bucket with CloudFront
resource "aws_s3_bucket_public_access_block" "catalogue" {
  bucket = aws_s3_bucket.catalogue.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#erver side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "catalogue" {
  bucket = aws_s3_bucket.catalogue.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "catalogue" {
  bucket = aws_s3_bucket.catalogue.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

#OAC
resource "aws_cloudfront_origin_access_control" "catalogue" {
  name                              = "terraform-catalogue-oac"
  description                       = "OAC policy for Terraform catalogue static site"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "catalogue" {
  enabled             = true
  default_root_object = "index.html"

  origin {
    domain_name              = aws_s3_bucket.catalogue.bucket_regional_domain_name
    origin_id                = "s3-terraform-catalogue"
    origin_access_control_id = aws_cloudfront_origin_access_control.catalogue.id
  }

  default_cache_behavior {
    target_origin_id       = "s3-terraform-catalogue"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}