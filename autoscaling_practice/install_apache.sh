#!/bin/bash
sudo yum update -y
sudo yum install httpd -y
echo "i am in autoscaled env" >>/var/www/html/index.html
sudo systemctl start httpd
sudo systemctl enable httpd
