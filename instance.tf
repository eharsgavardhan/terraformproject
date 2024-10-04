#security group
resource "aws_security_group" "security_project" {
  name        = "project"
  description = "security group "
   vpc_id = aws_vpc.harsha_project.id
  ingress {
    description = "Allow Port 80"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 ingress {
    description = "Allow Port 22"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    description = "Allow Port 443"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all ip and ports outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

#EC2_INSTANCE

resource "aws_instance" "harsha_instance" {
  ami           = var.ami
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.security_project.id] 
  subnet_id =aws_subnet.private_subnet_1.id
  key_name = "l-b"
   #user_data = file("apache-install.sh")
   user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install httpd -y
    sudo systemctl enable httpd
    sudo systemctl start httpd
    echo "<h1>Welcome to StackSimplify ! AWS Infra created using Terraform in us-east-1 Region</h1>" > /var/www/html/index.html
    EOF 
  tags = {
    Name = "today-project"
  }
}

resource "aws_instance" "harsha_instance_1" {
  ami           = var.ami
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.security_project.id] 
  subnet_id =aws_subnet.private_subnet_2.id
   key_name = "l-b"
   #user_data = file("apache-install.sh")
   user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install httpd -y
    sudo systemctl enable httpd
    sudo systemctl start httpd
    echo "<h1>Welcome to StackSimplify ! AWS Infra created using Terraform in us-east-1 Region</h1>" > /var/www/html/index.html
    EOF 

  tags = {
    Name = "today-project_1"
  }
}
