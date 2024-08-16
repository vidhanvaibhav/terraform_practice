resource aws_vpc webapp_vpc{
cidr_block=var.vpc_cidr
enable_dns_hostnames = true  
tags={
  Name="webapp"
}
}

resource "aws_internet_gateway" "webapp-igw" {
  vpc_id = aws_vpc.webapp_vpc.id

  tags = {
    Name = "webapp-igw"
  }
}

resource "aws_route_table" "webapp_pub-rt" {
  vpc_id = aws_vpc.webapp_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.webapp-igw.id
  }

  tags = {
    Name = "webapp_pub-rt"
  }
}


resource "aws_subnet" "webapp_pubsub1"{
vpc_id = aws_vpc.webapp_vpc.id
cidr_block=var.sub1_cidr
map_public_ip_on_launch = true
availability_zone="us-east-1a"
tags = {
   Name ="webapp_pubsub1"
}

}

resource "aws_subnet" "webapp_pubsub2"{
vpc_id = aws_vpc.webapp_vpc.id
cidr_block=var.sub2_cidr
map_public_ip_on_launch = true 
availability_zone="us-east-1b"
tags = {
   Name ="webapp_pubsub2"
}

}


resource "aws_route_table_association" "webapp_pubrta1" {
   subnet_id = aws_subnet.webapp_pubsub1.id 
   route_table_id = aws_route_table.webapp_pub-rt.id
}

resource "aws_route_table_association" "webapp_pubrta2" {
  subnet_id      = aws_subnet.webapp_pubsub2.id
  route_table_id = aws_route_table.webapp_pub-rt.id
}



resource "aws_security_group" "web_sg" {
  name        = "web-sg"
  vpc_id = aws_vpc.webapp_vpc.id

  description = "Allow SSH, HTTP, and HTTPS traffic"
  # Allow SSH from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow HTTP from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 egress {
   from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}

}
/*resource "aws_security_group" "app_sg" {
  name        = "app_sg"
  vpc_id = aws_vpc.webapp_vpc.id

  description = "Allow SSH, HTTP, and HTTPS traffic"
  # Allow SSH from anywhere
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }

  # Allow HTTP from anywhere
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }
 egress {
   from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}

}*/

