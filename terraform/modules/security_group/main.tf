# ELB SG

resource "aws_security_group" "elb_sg" {
  name        = "elb-security-group"
  description = "allow HTTP"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "elb-security-group"
    Owner = var.owner
  }
}

# front end SG
resource "aws_security_group" "frontend-sg" {
  name        = "frontend-sg-tomer&guy"
  description = "allow traffic from LB only"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # security_groups = [aws_security_group.elb_sg.id]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "frontend-sg-tomer&guy"
    Owner = var.owner
  }
}

# backend-sg SG
resource "aws_security_group" "backend-sg" {
  name        = "backend-sg-tomer&guy"
  description = "allow HTTP"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 8001
    to_port         = 8001
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend-sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "backend-sg-tomer&guy"
    Owner = var.owner
  }
}

resource "aws_security_group" "database-sg" {
  name        = "database-sg-tomer&guy"
  description = "allow database communication"
  vpc_id      = var.vpc_id

  ingress {
    from_port = 5432
    to_port   = 5432
    protocol  = "tcp"
    security_groups = [aws_security_group.backend-sg.id,
      var.eks_default_sg
    ]
  }
  ingress {
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.backend-sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "database-sg-tomer&guy"
    Owner = var.owner
  }
}


