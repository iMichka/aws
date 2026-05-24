output "route53_imichka_zone_id" {
  description = "The zone ID of the imichka.me Route53 hosted zone"
  value       = aws_route53_zone.imichka.zone_id
}
