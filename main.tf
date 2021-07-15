terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.49.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
}

resource "aws_vpc" "my_vpc" {
    cidr_block = "10.4.0.0/16"
    tags = {
        Name = "Manyu_vpc"
    }
}

resource "aws_subnet" "my_app-subnet" {
    tags = {
        Name = "Manyu_subnet"
    }
    vpc_id = aws_vpc.my_vpc.id
    cidr_block = "10.4.1.0/24"
    map_public_ip_on_launch = true
    depends_on = [aws_vpc.my_vpc]
}

resource "aws_route_table" "my_route-table" {
    tags ={
        Name = "MY_route_table"
    }
    vpc_id = aws_vpc.my_vpc.id
}

resource "aws_route_table_association" "App_Route_Association" {
    subnet_id = aws_subnet.my_app-subnet.id
    route_table_id = aws_route_table.my_route-table.id
}

resource "aws_internet_gateway" "my_IG" {
    tags = {
        Name = "My_Gateway"
    }
    vpc_id = aws_vpc.my_vpc.id
    depends_on = [aws_vpc.my_vpc]
}

resource "aws_route" "default_route" {
    route_table_id = aws_route_table.my_route-table.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_IG.id
}