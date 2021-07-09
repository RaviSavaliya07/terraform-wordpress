terraform {
  backend "s3" {
    bucket = "terraform-backends-prod"
    key    = "mykey"
    region = "ap-south-1"
    dynamodb_table = "test"
  }
}
