output "nodes_private_ips" {
  value = [
    for nodes in aws_spot_instance_request.nodes : nodes.private_ip
  ]
}

output "nodes_public_ips" {
  value = [for nodes in aws_spot_instance_request.nodes : nodes.public_ip]
}