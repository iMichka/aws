# resource "random_string" "admin-db-password" {
#   length  = 32
#   upper   = true
#   numeric = true
#   special = false
# }

# resource "aws_db_instance" "mastodon" {
#   identifier           = "mastodon"
#   db_name              = "mastodon"
#   instance_class       = "db.t3.micro"
#   allocated_storage    = 20
#   engine               = "postgres"
#   engine_version       = "14.6"
#   skip_final_snapshot  = true
#   publicly_accessible  = true
#   username             = "mastodon"
#   password             = "random_string.admin-db-password.result}"
#   db_subnet_group_name = aws_db_subnet_group.mastodon.id
# }
