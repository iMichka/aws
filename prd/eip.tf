resource "aws_eip" "mastodon-public-eip" {
  vpc = true
}
