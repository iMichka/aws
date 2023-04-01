# resource "aws_elasticache_cluster" "mastodon" {
#   cluster_id           = "mastodon"
#   engine               = "redis"
#   node_type            = "cache.t2.micro"
#   num_cache_nodes      = 1
#   parameter_group_name = "default.redis7"
#   engine_version       = "7.0"
#   port                 = 6379
#   subnet_group_name    = aws_elasticache_subnet_group.mastodon-redis-subnet-group.name
# }
