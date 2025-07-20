/***
Commenting this module since I deployed and created the ceritficate manually on the console to avoid errors
*/

# resource "aws_route53_zone" "primary" {
#   name = var.hosted_zone_name

#   tags = {
#     Name = "${var.project_name} Hosted Zone"
#   }
# }

# resource "aws_acm_certificate" "cert" {
#   # The domain name is now constructed from the subdomain and the hosted zone name.
#   domain_name       = "${var.subdomain_name}.${var.hosted_zone_name}"
#   validation_method = "DNS"

#   lifecycle {
#     create_before_destroy = true
#   }

#   tags = {
#     Name = "${var.subdomain_name}.${var.hosted_zone_name} Certificate"
#   }
# }

# resource "aws_route53_record" "validation" {
#   for_each = {
#     for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
#       name    = dvo.resource_record_name
#       record  = dvo.resource_record_value
#       type    = dvo.resource_record_type
#     }
#   }

#   allow_overwrite = true
#   name            = each.value.name
#   records         = [each.value.record]
#   ttl             = 60
#   type            = each.value.type
#   # This now points to the ID of the new aws_route53_zone resource.
#   zone_id         = aws_route53_zone.primary.zone_id
# }

# # 3. Wait for the validation process to complete.
# resource "aws_acm_certificate_validation" "cert_validation" {
#   certificate_arn         = aws_acm_certificate.cert.arn
#   validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]
# }