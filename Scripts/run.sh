#!/bin/bash

# Step 1: Initialize and apply Terraform to create infrastructure
cd terraform
terraform init
terraform apply -auto-approve

# Step 2: Get instance IPs from Terraform output
INSTANCE_IPS=$(terraform output -json instance_ips | jq -r '.[]')

# Step 3: Prepare Ansible inventory dynamically from Terraform output
echo "[loadtest]" > ../ansible/inventory.ini
for ip in $INSTANCE_IPS; do
  echo "$ip ansible_user=your-username ansible_ssh_private_key_file=~/.ssh/id_rsa" >> ../ansible/inventory.ini
done

# Step 4: Use Ansible to install k6 on the instances
cd ../ansible
ansible-playbook -i inventory.ini playbooks/install_k6.yml

# Step 5: Run k6 load test using Ansible
ansible-playbook -i inventory.ini playbooks/run_k6_test.yml

# Step 6: Cleanup - Destroy all infrastructure after load test is done
cd ../terraform
terraform destroy -auto-approve
