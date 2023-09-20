resource "aws_s3_bucket" "imichka-mastodon" {
  bucket = "imichka-mastodon"
}

resource "aws_s3_bucket" "imichka-ansible" {
  bucket = "imichka-ansible"
}

resource "aws_s3_bucket_lifecycle_configuration" "imichka-ansible-s3-configuration" {
  bucket = aws_s3_bucket.imichka-ansible.id

  rule {
    id = "logs-7-days-retention"

    filter {
      prefix = "output/"
    }

    expiration {
      days = 7
    }

    status = "Enabled"
  }

  rule {
    id = "backup-30-days-retention"

    filter {
      prefix = "backup-postgres/"
    }

    expiration {
      days = 30
    }

    status = "Enabled"
  }
}
