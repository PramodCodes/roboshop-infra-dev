#!/bin/bash
set -x  # add e for killing the script if any command fails
rm -rf /tmp/roboshop-ansible-roles*
sleep 1.5m
yum install ansible -y
echo "Provisioning EC2 instance with ansible"
cd /tmp
git clone https://github.com/PramodCodes/roboshop-ansible-roles.git
cd roboshop-ansible-roles
echo pwd
# # Array of components
# components=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "web")

# # Loop through each component and run the playbook
# for component in "${components[@]}"
# do
#     ansible-playbook -e component=$component main.yaml
# done
ansible-playbook -e component=mongodb main.yaml
ansible-playbook -e component=redis main.yaml
ansible-playbook -e component=rabbitmq main.yaml
ansible-playbook -e component=mysql main.yaml
ansible-playbook -e component=catalogue main.yaml
ansible-playbook -e component=user main.yaml
ansible-playbook -e component=cart main.yaml
ansible-playbook -e component=shipping main.yaml
ansible-playbook -e component=payment main.yaml
ansible-playbook -e component=web main.yaml