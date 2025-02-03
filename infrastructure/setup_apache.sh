#! /bin/bash
sudo yum update -y
sudo yum install -y httpd.x86_64
sudo systemctl enable httpd --now

echo "<html><body><h1>PIN 2 EJECUTANTOSE!</h1></body></html>" | sudo tee /var/www/html/index.html
