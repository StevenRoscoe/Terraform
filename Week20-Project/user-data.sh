#!/bin/bash
sudo yum -y update 
sudo yum -y install httpd 
systemctl enable httpd
systemctl start httpd

echo "<!DOCTYPE html>
<html>
<head>
</head>
<body>
    <h1>Welcome to the page Green Team!</h1>
</body>
</html>" >> var/www/html/index.html
