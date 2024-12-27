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
