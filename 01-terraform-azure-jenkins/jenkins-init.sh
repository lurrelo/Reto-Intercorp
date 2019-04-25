#!/bin/bash

# install jenkins
#wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
#echo "deb http://pkg.jenkins.io/debian-stable binary/" >> /etc/apt/sources.list
#apt-get update
#apt-get install -y jenkins=2.32.1

apt-get update -y
apt-get remove java-1.7.0-openjdk -y
apt-get install java-1.8.0-openjdk -y
apt-get install git -y
apt-get install -y docker
curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/bin/docker-compose
chmod +x /usr/bin/docker-compose
wget -q -O - https://pkg.jenkins.io/debian/jenkins-ci.org.key | sudo apt-key add -
sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
echo "deb http://pkg.jenkins.io/debian-stable binary/" >> /etc/apt/sources.list
apt-get install jenkins -y
usermod -aG docker jenkins
usermod -a -G docker ubuntu
service docker start
service jenkins start