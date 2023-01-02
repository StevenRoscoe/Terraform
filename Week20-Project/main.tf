#------main.tf------#
#All done in AWS Cloud9

#AWS Provider from Terraform Registry
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

#AWS provider with default region
provider "aws" {
  region = "us-east-1"
}

#Key Pair for resources
#resource "aws_key_pair" "" {
#  key_name   = ""
#  public_key = ""
#}

#VPC for resources
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "main_vpc"
  }
}

#Internet Gateway for access to the internet
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.main_vpc.id

  tags = {
    Name = "IGW"
  }
}

#Route Table paired with our Internet Gateway
resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.main_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = {
    Name = "RT"
  }
}

#Subnet 1
resource "aws_subnet" "sub1" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.16.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "AZ1A"
  }
}

#Subnet 2
resource "aws_subnet" "sub2" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.128.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "AZ1B"
  }
}

#Subnet 3
resource "aws_subnet" "sub3" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.144.0/24"
  availability_zone       = "us-east-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "AZ1C"
  }
}

#Subnet Assoc. 1
resource "aws_route_table_association" "R1" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.RT.id
}

#Subnet Assoc. 2
resource "aws_route_table_association" "R2" {
  subnet_id      = aws_subnet.sub2.id
  route_table_id = aws_route_table.RT.id
}

#Subnet Assoc. 3
resource "aws_route_table_association" "R3" {
  subnet_id      = aws_subnet.sub3.id
  route_table_id = aws_route_table.RT.id
}

#Security Group
resource "aws_security_group" "Terraform_SG" {
  name        = "Terraform_SG"
  description = "Security Group for Terraform Project (HTTP/SSH)"
  vpc_id      = aws_vpc.main_vpc.id

  #Inbound SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Inbound HTTP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#First EC2 instance
resource "aws_instance" "server1" {
  ami             = "ami-0b5eea76982371e91"
  instance_type   = "t2.micro"
  key_name        = "Terraform"
  security_groups = [aws_security_group.Terraform_SG.id]
  subnet_id       = aws_subnet.sub1.id
  user_data       = file("user-data.sh")

  tags = {
    Name = "instance1"
  }
}

#Second EC2 instance
resource "aws_instance" "server2" {
  ami             = "ami-0b5eea76982371e91"
  instance_type   = "t2.micro"
  key_name        = "Terraform"
  security_groups = [aws_security_group.Terraform_SG.id]
  subnet_id       = aws_subnet.sub2.id
  user_data       = file("user-data.sh")

  tags = {
    Name = "instance2"
  }
}

#Third EC2 instance
resource "aws_instance" "server3" {
  ami             = "ami-0b5eea76982371e91"
  instance_type   = "t2.micro"
  key_name        = "Terraform"
  security_groups = [aws_security_group.Terraform_SG.id]
  subnet_id       = aws_subnet.sub3.id
  user_data       = file("user-data.sh")

  tags = {
    Name = "instance3"
  }
}