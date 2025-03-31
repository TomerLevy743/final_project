
region             = "us-east-1"
availability_zones = ["us-east-1a", "us-east-1b"]

#prefix for resource naming
naming = "tomer-guy-"

#route53
route53_name   = "status-page.org"
route53_zoneID = "Z04520012OG00EVC9GKI3"

#key
secert_key = "O32MGYzFbXL4EqKgVpwrDT)8s5L05A-z%Rcfr67Blzp@g7!d0@"

#Django Super User
superuser_name     = "admin"
superuser_password = "admin"
superuser_email    = "tomer.levy@nitzanim.tech"


#ECR
image_repository_statuspage = "992382545251.dkr.ecr.us-east-1.amazonaws.com/tomer-guy-final-project/app"
image_repository_nginx      = "992382545251.dkr.ecr.us-east-1.amazonaws.com/tomer-guy-final-project/nginx"

#RDS
db_username = "admin_statuspage"
db_password = "0123456789"
db_name     = "db_statuspage"
