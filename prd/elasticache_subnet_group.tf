resource "aws_elasticache_subnet_group" "mastodon-redis-subnet-group" {
  name       = "mastodon-redis-subnet-group"
  subnet_ids = [aws_subnet.private-mastodon-db-a.id, aws_subnet.private-mastodon-db-b.id]

  tags = {
    Name = "mastodon-redis-subnet-group"
  }
}
