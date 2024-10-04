resource "aws_db_subnet_group" "book-shop-subnet" {
  name       = var.db_subnet_name
  subnet_ids = [var.db_1_subnet_cidr_block, var.db_2_subnet_cidr_block] # Replace with your private subnet IDs
}

resource "aws_db_instance" "book-db" {
  identifier              = "book-db"
  engine                  = "mysql"
  engine_version          = "5.7"
  instance_class          = "db.t2.micro"
  allocated_storage       = 20
  username                = var.db_username
  password                = var.db_userpassword
  db_name                 = var.db_name
  multi_az                = true
  storage_type            = "gp2"
  storage_encrypted       = false
  publicly_accessible     = false
  skip_final_snapshot     = true
  backup_retention_period = 0

  vpc_security_group_ids = [aws_security_group.security_project.id] # Replace with your desired security group ID

  db_subnet_group_name = aws_db_subnet_group.book-shop-subnet.name

  tags = {
    Name = "rds_project"
  }
}