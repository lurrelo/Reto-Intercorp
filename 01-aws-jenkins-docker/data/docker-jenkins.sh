#!/bin/bash
sudo yum update -y
sudo yum install -y docker
sudo service docker start
sudo usermod -a -G docker ec2-user
logout
curl -L https://github.com/docker/compose/releases/download/1.6.1/docker-compose-`uname -s`-`uname -m` > docker-compose
sudo chown root docker-compose
sudo mv docker-compose /usr/local/bin
sudo chmod +x /usr/local/bin/docker-compose
sudo yum install -y git
sudo git clone https://github.com/lurrelo/jenkins-ec2-docker.git
cd jenkins-ec2-docker/
docker pull jenkins/jenkins
docker-compose build
docker-compose up -d
sudo cat ~/Jenkins/secrets/initialAdminPassword