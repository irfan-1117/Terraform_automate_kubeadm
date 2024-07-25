resource "random_string" "s3name" {
  length  = 9
  special = false
  upper   = false
  lower   = true
}

resource "aws_s3_bucket_acl" "s3_bucket_acl" {
  bucket     = aws_s3_bucket.s3buckit.id
  acl        = "private"
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.s3buckit.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket" "s3buckit" {
  bucket        = "k8s-${random_string.s3name.result}"
  force_destroy = true
  depends_on = [
    random_string.s3name
  ]
}
