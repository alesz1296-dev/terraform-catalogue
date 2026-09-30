output "bucket_name" {
  description = "Name of the S3 bucket used to store static website files."
  value       = aws_s3_bucket.catalogue.bucket
}

output "bucket_arn" {
  description = "ARN of the S3 bucket used to store static website files."
  value       = aws_s3_bucket.catalogue.arn
}

output "bucket_region" {
  description = "AWS region where the S3 bucket was created."
  value       = aws_s3_bucket.catalogue.region
}

output "cloudfront_domain_name" {
  description = "CloudFront domain name for the static website."
  value       = aws_cloudfront_distribution.catalogue.domain_name
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID used for cache invalidations."
  value       = aws_cloudfront_distribution.catalogue.id
}