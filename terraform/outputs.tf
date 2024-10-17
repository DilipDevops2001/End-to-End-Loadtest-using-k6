# Output the EC2 public IP addresses as a file for Ansible inventory
output "instance_public_ips" {
  value = aws_instance.k6_instance[*].public_ip
}

# Write the inventory for Ansible
resource "local_file" "ansible_inventory" {
  content = <<EOT
[loadtest_nodes]
%{ for ip in aws_instance.k6_instance[*].public_ip ~}
${ip} ansible_ssh_user=ec2-user ansible_ssh_private_key_file=~/.ssh/your_key.pem
%{ endfor ~}
EOT
  filename = "${path.module}/../ansible/hosts"
}
