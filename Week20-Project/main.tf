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
resource "aws_key_pair" "Terraform" {        
  key_name   = "Terraform"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCZ4xgrvBOr+KvWMjF4ftU5u1v8VJ9RtiM7gqbLWcCQWSJ2wYaUyEeToqH/vTV8ti4uyaxM14plJWCENi0ohwPGe+6N1l4Y1Nlk06Jbo+5HRsyMyh34dv+ixp7MM48tqnBEvolv00CaePgzGdO4JDX5DOZhgV74hiVSSk6ZNwNLJgM967Qr9uHQXyNd6e5dIghEQbRZI3Y3I2T/RqOR1bakSJtDZ0GL3xbtD92Xo8lZM1rbaUzT/meki+ZjhrX1Ppc9V2Rk/mlWao1lerL9rOnmnulZ+IyWjAw+Tp0XW2NHYfz7c03BE9nIRrS2ehnolnAMykwtOO98AwW+TEFPTmnh Terraform"
}

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
    cidr_block = "10.0.1.0/24"
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = {
    Name = "RT"
  }
}

#Subnet 1
resource "aws_subnet" "sub1" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "AZ1A"
  }
}

#Subnet 2
resource "aws_subnet" "sub2" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "AZ1B"
  }
}

#Subnet 3
resource "aws_subnet" "sub3" {
  vpc_id     = aws_vpc.main_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1c"
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


resource "aws_instance" "server1" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld"
  }
}


resource "aws_instance" "server2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld"
  }
}


resource "aws_instance" "server3" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld"
  }
}