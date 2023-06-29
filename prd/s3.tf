resource "aws_s3_bucket" "imichka-mastodon" {
  bucket = "imichka-mastodon"
}

resource "aws_s3_bucket" "imichka-ansible" {
  bucket = "imichka-ansible"

  lifecycle_rule {
    id      = "logs-7-days-retention"
    prefix  = "output"
    enabled = true

    expiration {
      days = 7
    }
  }
}
