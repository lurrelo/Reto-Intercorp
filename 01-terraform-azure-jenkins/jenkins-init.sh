#!/bin/bash


#wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
#echo "deb http://pkg.jenkins.io/debian-stable binary/" >> /etc/apt/sources.list
#apt-get update
#apt-get install -y jenkins

sudo apt-get update
sudo add-apt-repository ppa:openjdk-r/ppa
sudo apt-get update
sudo apt-get install openjdk-8-jdk
java -version
sudo apt-get install git
sudo apt-get install docker
sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/bin/docker-compose
sudo chmod +x /usr/bin/docker-compose
sudo wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
sudo apt-get install jenkins
sudo usermod -aG docker jenkins
sudo usermod -a -G docker ubuntu
sudo service docker start
sudo service jenkins start
