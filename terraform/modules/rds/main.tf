# module "rds" {
#   source  = "terraform-aws-modules/rds/aws"
#   version = "6.3.0"

#   identifier = "tomer-guy-rds-instance"

#   engine            = "postgres"
#   engine_version    = "17.2"
#   instance_class    = "db.t3.micro"
#   allocated_storage = 20

#   db_name  = "db_statuspage"
#   username = "admin_statuspage"
#   password = "0123456789"

#   vpc_security_group_ids  = [var.database-sg]
#   db_subnet_group_name    = aws_db_subnet_group.statuspage_subnet_group.name
#   subnet_ids              = var.subnet_ids
#   multi_az                = false
#   publicly_accessible     = false
#   storage_encrypted       = true
#   backup_retention_period = 7

#   # Add the db_parameter_group configuration here
#   # parameter_group_name = "tomer-guy-db-parameter-group"
#   family               = "postgres17"

#   tags = {
#     Owner = var.owner
#   }
# }
resource "aws_db_instance" "statuspage_db" {
  identifier             = "${var.naming}statuspage-db"
  engine                 = "postgres"
  engine_version         = "17.2"
  instance_class         = "db.t3.micro"
  allocated_storage      = 20
  storage_type           = "gp2"
  username               = var.db_username
  password               = var.db_password
  db_name                = var.db_name
  parameter_group_name   = aws_db_parameter_group.parameter_group.name
  publicly_accessible    = false
  skip_final_snapshot    = true
  vpc_security_group_ids = [var.database-sg]
  db_subnet_group_name   = aws_db_subnet_group.statuspage_subnet_group.name
  tags = {
    Owner = var.owner
  }
}



resource "aws_db_parameter_group" "parameter_group" {
  name   = "${var.naming}pg"
  family = "postgres17"

  parameter {
    name  = "rds.force_ssl"
    value = "0"
  }

  tags = {
    Name  = "tomer-guy-pg"
    Owner = var.owner
  }
}


resource "aws_db_subnet_group" "statuspage_subnet_group" {
  name       = "${var.naming}statuspage-subnet-group"
  subnet_ids = var.subnet_ids
  tags = {
    Owner = var.owner
  }
}
