terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.50.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

resource "aws_s3_bucket" "source" {
  bucket = "source-bucket-daniela"

  force_destroy = true
}

resource "aws_s3_bucket_versioning" "source" {
  bucket = aws_s3_bucket.source.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_access_point" "source" {
  # Must have bucket versioning enabled first
  bucket = aws_s3_bucket_versioning.source.bucket
  name   = "source-daniela-accesspoint"
}

resource "aws_s3_bucket" "target" {
  bucket = "target-bucket-daniela"
}

resource "aws_s3_bucket_versioning" "target" {
  bucket = aws_s3_bucket.target.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_access_point" "target" {
  # Must have bucket versioning enabled first
  bucket = aws_s3_bucket_versioning.target.bucket
  name   = "target-daniela-accesspoint"
}

resource "aws_s3_object" "source" {
  bucket = aws_s3_bucket.source.bucket
  key    = "key-source"
}

resource "aws_s3_object_copy" "test" {
  bucket = aws_s3_access_point.target.arn
  key    = "key-target"
  source = "${aws_s3_access_point.source.arn}/object/${aws_s3_object.source.key}"
}
