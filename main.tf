provider "aws" {
  region = "ap-south-1"
}
resource "aws_key_pair" "test" {
  key_name   = "test"
  public_key = tls_private_key.rsa.public_key_openssh
}
resource "tls_private_key" "rsa" {
algorithm = "RSA"
rsa_bits  = 4096
}

resource "aws_instance" "main" {
  ami = "ami-0f8ca728008ff5af4"
  instance_type = "t2.micro"
  key_name = "test"
  availability_zone = "var.availability_zone"
  subnet_id  = "${aws_subnet.testpublic.id}"
  associate_public_ip_address = true
}

#creating vpc
resource "aws_vpc" "vpc" {
   cidr_block = "${var.vpc_vpc_cidr}"
   instance_tenancy = "default"
}

# creating public subnet
resource "aws_subnet" "testpublic" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${var.testpublic}"
  availability_zone = "ap-south-1a"
}

#creating private subnet
resource "aws_subnet" "testprivate" {
  vpc_id = "${aws_vpc.vpc.id}"
  cidr_block = "${var.testprivate}"
  availability_zone = "ap-south-1a"
 }
   
#creating internet gateway  
resource "aws_internet_gateway" "some_ig" {
  vpc_id = "${aws_vpc.vpc.id}"
}

#creating route table
resource "aws_route_table" "testrt" {
  vpc_id = "${aws_vpc.vpc.id}"
}

#Associate Public Subnet 1 to "Public Route Table"
resource "aws_route_table_association" "testpublic-rt-association" {
subnet_id           = aws_subnet.testpublic.id
route_table_id      = aws_route_table.testrt.id
}

#creating security group
resource "aws_security_group" "sgtest" {
  name = "sgtest"
  vpc_id = "${aws_vpc.vpc.id}"

  ingress{ 
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
   
   ingress{ 
    from_port = 22
    to_port   = 22
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 
    egress{ 
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


