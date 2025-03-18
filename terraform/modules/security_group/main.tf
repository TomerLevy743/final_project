

# front end SG
resource "aws_security_group" "nginx_sg" {
  name        = "ec2-nginx-security-group"
  description = "allow traffic from LB only"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = [443, 80]
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.elb_sg.id]
  }

  # allowing ssh access only from host machine by fetching their public ip


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name  = "nginx-security-group"
    Owner = var.owner
  }
}


# ELB SG

resource "aws_security_group" "elb_sg" {
  name        = "elb-security-group"
  description = "allow HTTP"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
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


