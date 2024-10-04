#vpc
resource "aws_vpc" "harsha_project" {
    cidr_block = var.vpc_cidr_block
    instance_tenancy        = "default"
    enable_dns_hostnames    = true
    enable_dns_support =  true

  tags      = {
    Name    = "vpc_project"
  }
}
#internet gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id    = aws_vpc.harsha_project.id

  tags      = {
    Name    = "project_igw"
  }
}
data "aws_availability_zones" "available_zones" {}
# public subent
resource "aws_subnet" "public_subnet_1" {
    vpc_id = aws_vpc.harsha_project.id
    cidr_block = var.subnet_cidr_block
    availability_zone       = data.aws_availability_zones.available_zones.names[0]
      map_public_ip_on_launch = true
    tags      = {
    Name    = "public_subnet_1"
  }

}
resource "aws_subnet" "public_subnet_2" {
    vpc_id = aws_vpc.harsha_project.id
    cidr_block = var.subnet_cidr_block
    availability_zone       = data.aws_availability_zones.available_zones.names[0]
    map_public_ip_on_launch = true
    tags      = {
    Name    = "public_subnet_2"
  }
}
#route table 
resource "aws_route_table" "public_route_table" {
  vpc_id       = aws_vpc.harsha_project.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags       = {
    Name     = "project_route"
  }
}

# associate public subnet pub-sub-1-a to "public route table"
resource "aws_route_table_association" "pub-sub-1-a_route_table_association" {
  subnet_id           = aws_subnet.public_subnet_1.id
  route_table_id      = aws_route_table.public_route_table.id
}

# associate public subnet az2 to "public route table"
resource "aws_route_table_association" "pub-sub-1-b_route_table_association" {
  subnet_id           = aws_subnet.public_subnet_1.id
  route_table_id      = aws_route_table.public_route_table.id
}
#private subnet
resource "aws_subnet" "private_subnet_1" {
    vpc_id = aws_vpc.harsha_project.id
    cidr_block = var.private_1_subnet_cidr_block
    availability_zone       = data.aws_availability_zones.available_zones.names[0]
    map_public_ip_on_launch = true
    tags      = {
    Name    = "private_subnet_1"
  }
}
resource "aws_subnet" "private_subnet_2" {
    vpc_id = aws_vpc.harsha_project.id
    cidr_block = var.private_2_subnet_cidr_block
    availability_zone       = data.aws_availability_zones.available_zones.names[1]
    map_public_ip_on_launch = true
    tags      = {
    Name    = "private_subnet_2"
  }
}
#database subnet
resource "aws_subnet" "database_subnet_1" {
    vpc_id = aws_vpc.harsha_project.id
    cidr_block = var.db_1_subnet_cidr_block
    availability_zone       = data.aws_availability_zones.available_zones.names[0]
    map_public_ip_on_launch = true
    tags      = {
    Name    = "db_subnet_1"
  }
}
resource "aws_subnet" "database_subnet_2" {
    vpc_id = aws_vpc.harsha_project.id
    cidr_block = var.db_2_subnet_cidr_block
    availability_zone       = data.aws_availability_zones.available_zones.names[1]
    map_public_ip_on_launch = true
    tags      = {
    Name    = "db_subnet_2"
  }
}