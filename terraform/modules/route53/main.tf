resource "aws_route53_record" "status_page" {
  zone_id = var.route53_zoneID
  name    = var.route53_name
  type    = "A"

  alias {
    name                   = module.alb.alb_dns_name
    zone_id                = module.alb.alb_zone_id
    evaluate_target_health = true
  }
}