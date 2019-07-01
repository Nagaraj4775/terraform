provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "terraform_vpc"
  }
}

resource "aws_internet_gateway" "terraformGW" {
    vpc_id = aws_vpc.main.id
    tags = {
        Name = "terraform_IGW"
    }
}

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true

  tags = {
    Name = "Terrform_Public_1"
  }
}

resource "aws_subnet" "public_subnet_2" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.2.0/24"
    availability_zone = "us-east-1b"
    map_public_ip_on_launch = true

  tags = {
    Name = "Terrform_Public_2"
  }
}

resource "aws_route_table" "publicroute" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.terraformGW.id 
    }
    tags = {
        Name = "Terraform_MainRoute"
    }
}

resource "aws_route_table_association" "publicassociation" {
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.publicroute.id
}

resource "aws_route_table_association" "publicassociation_2" {
    subnet_id = aws_subnet.public_subnet_2.id
    route_table_id = aws_route_table.publicroute.id
}

resource "aws_security_group" "common_SG" {
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform_publicAccess"
  }
}
