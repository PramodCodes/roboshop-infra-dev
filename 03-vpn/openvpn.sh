#!/bin/bash
# non-interactive or headless installation
export AUTO_INSTALL=y
# the following line give public address of the instance where ever you run the fowlling line
export ENDPOINT=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)
export APPROVE_INSTALL=y
export APPROVE_IP=y
export IPV6_SUPPORT=n
export PORT_CHOICE=1
export PROTOCOL_CHOICE=2
export DNS=1
export COMPRESSION_ENABLED=n
export CUSTOMIZE_ENC=n
# you can change the following name as per your requirement
export CLIENT=devops76s
export PASS=1
curl -O https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh
chmod +x openvpn-install.sh
./openvpn-install.sh
#once config is complete lets copy the client.ovpn file to the local machine we can download with mobaxterm
cp /root/devops76s.ovpn /home/centos
echo "openvpn installation successful"
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
