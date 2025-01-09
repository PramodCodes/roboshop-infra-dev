#!/bin/bash
set -xe
sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum -y upgrade
# Add required dependencies for the jenkins package
sudo yum -y install fontconfig java-17-openjdk
# sudo yum -y install jenkins
sudo systemctl daemon-reload
# sudo systemctl enable jenkins
# sudo systemctl start jenkins
# sudo systemctl status jenkins
# echo "jenkins installation successful Installing terraform"
sudo yum -y install yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install terraform
ehco "terraform installation successful setting nodejs for catalogue"
dnf module disable nodejs -y
dnf module enable nodejs:18 -y
dnf install nodejs -y
# cat /var/lib/jenkins/secrets/initialAdminPassword
