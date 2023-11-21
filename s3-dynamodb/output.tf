output "bucket_name_output" {
  value = aws_s3_bucket.terra_s3.bucket
}

output "dynamodb_name_output" {
  value = aws_dynamodb_table.terra_ddb_state_lock.name
}