resource "aws_db_subnet_group" "mastodon" {
  name       = "mastodon"
  subnet_ids = [aws_subnet.private-mastodon-db-a.id, aws_subnet.private-mastodon-db-b.id]

  tags = {
    Name = "mastodon-db-subnet-group"
  }
}
