provider "aws" {
  region      = var.region
  access_key  = var.access_key
  secret_key = var.secret_key
}

resource "aws_instance" "mypubinstance" {
  instance_type = var.instance
  ami           = var.ami_id
  subnet_id=aws_subnet.webapp_pubsub1.id
  key_name="vidhan"
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  user_data =file("/home/ec2-user/install_apache.sh") 
  tags = {
    Name = "mypubinstance"
  }
 
}
resource "aws_instance" "myprinstance" {
  instance_type = var.instance
  ami           = var.ami_id
  subnet_id=aws_subnet.webapp_pubsub2.id
  key_name="vidhan"
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  user_data =file("/home/ec2-user/install_nginx.sh")

tags = {
    Name = "myprinstance"
  }
}

output "instance_private_ip" {
  value = aws_instance.myprinstance.private_ip
}

