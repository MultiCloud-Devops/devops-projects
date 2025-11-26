#--------------------------------------
# RDS subnet group
#--------------------------------------
resource "aws_db_subnet_group" "tfsp_rds_subnet_group" {
  name       = "tfsp-${var.envname}-rds-subnet-group"
  subnet_ids = var.vpc_private_subnets

  tags = {
    Name = "tfsp-${var.envname}-rds-subnet-group"
  }
}


#--------------------------------------
# RDS Security Group
#--------------------------------------
resource "aws_security_group" "tfsp_rds_security_group" {
  name        = "tfsp-${var.envname}-rds-sg"
  description = "Security group for RDS instance"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.rds_security_group_ingress
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "tfsp-${var.envname}-rds-sg"
  }
}


#--------------------------------------
# RDS Instance  
#--------------------------------------
resource "aws_db_instance" "tfsp_rds_instance" {
  identifier             = "tfsp-${var.envname}-rds-db"
  allocated_storage      = var.rds_db_allocated_storage
  engine                 = var.rds_db_engine
  engine_version         = var.rds_db_engine_version
  instance_class         = var.rds_db_instance_class
  username               = local.tfsp_db_username
  password               = local.tfsp_db_password
  db_subnet_group_name   = aws_db_subnet_group.tfsp_rds_subnet_group.name
  vpc_security_group_ids = [aws_security_group.tfsp_rds_security_group.id]
  skip_final_snapshot    = true
  publicly_accessible    = false
  storage_encrypted      = true
  multi_az               = false
  deletion_protection    = false
  kms_key_id             = local.tfsp_rds_kms_key_arn
  depends_on             = [aws_db_subnet_group.tfsp_rds_subnet_group, aws_security_group.tfsp_rds_security_group]

  tags = {
    Name = "tfsp-${var.envname}-rds-db"
  }
}

 