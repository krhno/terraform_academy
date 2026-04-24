provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "testing" {
  bucket = "terraform-academy-bucket_oruiz"
  tags = {
    academy = "terraform202601"
  }
}
