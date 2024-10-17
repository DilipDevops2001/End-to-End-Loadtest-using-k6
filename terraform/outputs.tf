# Output public IPs of instances
output "instance_public_ips" {
  value = google_compute_instance.loadtest_instance[*].network_interface[0].access_config[0].nat_ip
}

# Generate Ansible inventory
resource "local_file" "ansible_inventory" {
  content = <<EOT
[loadtest_nodes]
%{ for ip in google_compute_instance.loadtest_instance[*].network_interface[0].access_config[0].nat_ip ~}
${ip} ansible_ssh_user=your-gcp-username ansible_ssh_private_key_file=~/.ssh/your_key.pem
%{ endfor ~}
EOT
  filename = "${path.module}/../ansible/inventory.ini"
}
