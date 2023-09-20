resource "aws_route53_zone" "imichka" {
  name = "imichka.me"
}

resource "aws_route53_record" "mastodon" {
  zone_id = aws_route53_zone.imichka.zone_id
  name    = "mastodon.imichka.me"
  type    = "A"
  ttl     = 300
  records = [aws_eip.mastodon-public-eip.public_ip]
}

resource "aws_route53_record" "files" {
  zone_id = aws_route53_zone.imichka.zone_id
  name    = "files.imichka.me"
  type    = "A"
  ttl     = 300
  records = [aws_eip.mastodon-public-eip.public_ip]
}
