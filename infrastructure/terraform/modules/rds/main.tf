resource "aws_db_subnet_group" "main" {
  name       = "hr-ops-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "hr-ops-db-subnet-group"
  }
}

resource "aws_security_group" "rds" {
  name        = "hr-ops-rds-sg"
  description = "Security group for HR Ops RDS database"
  vpc_id      = var.vpc_id

  ingress {
    description = "PostgreSQL access"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"

    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "hr-ops-rds-sg"
  }
}

resource "aws_db_instance" "main" {
  identifier = "hr-ops-postgres"

  engine         = "postgres"
  engine_version = "16"
  instance_class = "db.t3.micro"

  allocated_storage = 20
  storage_type      = "gp3"

  db_name  = var.db_name
  username = var.db_username

  manage_master_user_password = true

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  multi_az            = true
  publicly_accessible = false

  skip_final_snapshot = true
  deletion_protection = false

  tags = {
    Name = "hr-ops-postgres"
  }
}