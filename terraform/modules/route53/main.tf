


data "aws_lb" "eks_alb" {
  # depends_on = [helm_release.alb-controller]  # Ensure ALB exists before fetching

  # Identify ALB using its name
  name = "tomer-guy-loadbalancer"  # Make sure this is the correct ALB name!
}

output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = data.aws_lb.eks_alb.dns_name
}

output "alb_zone_id" {
  description = "The hosted zone ID of the ALB"
  value       = data.aws_lb.eks_alb.zone_id
}






resource "aws_route53_record" "status_page" {
  zone_id = var.route53_zoneID
  name    = var.route53_name
  type    = "A"

  alias {
    name                   = data.aws_lb.eks_alb.dns_name
    zone_id                = data.aws_lb.eks_alb.zone_id
    evaluate_target_health = true
  }
}


