resource "aws_s3_bucket" "imichka-terraform-state" {
  bucket = "imichka-terraform-state"
}

resource "aws_s3_bucket_versioning" "terraform_state_bucket_versioning" {
  bucket = aws_s3_bucket.imichka-terraform-state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "dynamodb_terraform_state_lock" {
  name           = "dynamodb_terraform_state_lock"
  hash_key       = "LockID"
  read_capacity  = 20
  write_capacity = 20
  tags = {
    Name = "DynamoDB Terraform State Lock Table"
  }
  attribute {
    name = "LockID"
    type = "S"
  }
}

terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "imichka-terraform-state"
    key            = "tfstate-s3-bucket"
    region         = "eu-west-3"
    dynamodb_table = "dynamodb_terraform_state_lock"
  }
}
