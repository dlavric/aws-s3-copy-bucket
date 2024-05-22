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
  bucket = "source-bucket-daniela-new"

  force_destroy = true
}


resource "aws_s3_object" "source" {
  bucket = aws_s3_bucket.source.bucket
  key    = "key-source-new"
}

resource "aws_s3_object_copy" "test" {
  bucket = aws_s3_bucket.source.bucket
  key    = "key-target-new"
  source = "${aws_s3_bucket.source.bucket}/${aws_s3_object.source.key}"
}
