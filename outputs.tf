output "nodes_private_ips" {
  value = [
    for nodes in aws_spot_instance_request.nodes : nodes.private_ip
  ]
}

output "nodes_public_ips" {
  value = [for nodes in aws_spot_instance_request.nodes : nodes.public_ip]
}

output "ssh_command" {
  value = (formatlist(
    "ssh -i id_rsa ubuntu@%s",
    [for nodes in aws_spot_instance_request.nodes : nodes.public_ip]
  ))
}

output "variable_kubeconfig" {
  value = "export KUBECONFIG=$PWD/kubeconfig"
}