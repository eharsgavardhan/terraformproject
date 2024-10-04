resource "aws_eip" "elastic_ip_nat_A" {
  domain = aws_vpc.harsha_project.id

  tags   = {
    Name = "NAT-GW-EIP-A"
  }
}

# allocate elastic ip. this eip will be used for the nat-gateway in the public subnet pub-sub-2-b
resource "aws_eip" "elastic_ip_nat_B" {
 domain = aws_vpc.harsha_project.id
  tags   = {
    Name = "NAT-GW-EIP-B"
  }
}

# create nat gateway in public subnet pub-sub-1-a
resource "aws_nat_gateway" "NAT-GW-A" {
  allocation_id = aws_eip.elastic_ip_nat_A.id
  subnet_id     = aws_subnet.public_subnet_1.id

  tags   = {
    Name = "NAT-GW-A"
  }

  # to ensure proper ordering, it is recommended to add an explicit dependency
  depends_on = [aws_internet_gateway.internet_gateway]
}

# create nat gateway in public subnet pub-sub-1-a
resource "aws_nat_gateway" "NAT-GW-B" {
  allocation_id = aws_eip.elastic_ip_nat_B.id
  subnet_id     = aws_subnet.public_subnet_2.id

  tags   = {
    Name = "NAT-GW-B"
  }

  # to ensure proper ordering, it is recommended to add an explicit dependency
  # on the internet gateway for the vpc.
  depends_on = [aws_internet_gateway.internet_gateway]
}

# create private route table Pri-RT-A and add route through NAT-GW-A
resource "aws_route_table" "Pri-RT-A" {
  vpc_id            = aws_vpc.harsha_project.id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_eip.elastic_ip_nat_A.id
  }

  tags   = {
    Name = "Pri-RT-A"
  }
}

# associate private subnet pri-sub-3-a with private route table Pri-RT-A
resource "aws_route_table_association" "pri-sub-3-a-with-Pri-RT-A" {
  subnet_id         = aws_subnet.public_subnet_1.id
  route_table_id    = aws_route_table.Pri-RT-A.id
}

# associate private subnet pri-sub-5-a with private route table Pri-RT-A
resource "aws_route_table_association" "pri-sub-4-b-with-Pri-RT-B" {
  subnet_id         = aws_subnet.database_subnet_1.id
  route_table_id    = aws_route_table.Pri-RT-A.id
}

# create private route table Pri-RT-B and add route through NAT-GW-B
resource "aws_route_table" "Pri-RT-B" {
  vpc_id            = aws_vpc.harsha_project.id

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.NAT-GW-B.id
  }

  tags   = {
    Name = "Pri-RT-B"
  }
}

# associate private subnet pri-sub-4-b with private route Pri-RT-B
resource "aws_route_table_association" "pri-sub-5-a-with-Pri-RT-B" {
  subnet_id         = aws_subnet.private_subnet_2.id
  route_table_id    = aws_route_table.Pri-RT-B.id
}

# associate private subnet pri-sub-6-b with private route table Pri-RT-B
resource "aws_route_table_association" "pri-sub-6-b-with-Pri-RT-B" {
  subnet_id         = aws_subnet.database_subnet_2.id
  route_table_id    = aws_route_table.Pri-RT-B.id
}