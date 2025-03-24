resource "aws_db_instance" "statuspage_db" {
  identifier             = "tomer-guy-statuspage-db"
  engine                = "postgres"
  engine_version        = "17.2"
  instance_class        = "db.t3.micro"
  allocated_storage     = 20
  storage_type          = "gp2"
  username              = "admin_statuspage"
  password              = "0123456789"
  db_name               = "db_statuspage"
  publicly_accessible  = false
  skip_final_snapshot  = true
  vpc_security_group_ids = [var.database-sg]
  db_subnet_group_name   = aws_db_subnet_group.statuspage_subnet_group.name
}

resource "aws_db_subnet_group" "statuspage_subnet_group" {
  name       = "statuspage-subnet-group"
  subnet_ids = var.subnet_ids 
}
