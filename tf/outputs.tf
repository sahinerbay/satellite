output "bucket_name" {
  value       = "${aws_s3_bucket.satellite_fed.bucket}"
  description = "The name of the bucket."
}