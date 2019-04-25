#!/bin/bash

# install jenkins
#wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
#echo "deb http://pkg.jenkins.io/debian-stable binary/" >> /etc/apt/sources.list
#apt-get update
#apt-get install -y jenkins=2.32.1

wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get update
sudo apt-get install jenkins
usermod -aG docker jenkins
usermod -a -G docker ubuntu
apt-get update
apt-get remove java-1.7.0-openjdk
apt-get install java-1.8.0-openjdk
apt-get install git
apt-get install docker
curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/bin/docker-compose
chmod +x /usr/bin/docker-compose
service docker start
service jenkins start