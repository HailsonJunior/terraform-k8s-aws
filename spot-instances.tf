locals {
  nodes = {
    for i in range(1, 1 + var.how_many_nodes) :
    i => {
      node_name = i == 1 ? format("k8s-node%d-master", i) : (i == 2 ? format("k8s-node%d-master", i) : format("k8s-node%d-worker", i))
    }
  }
}

resource "aws_spot_instance_request" "nodes" {
  for_each                    = local.nodes
  ami                         = var.aws_ami
  instance_type               = var.aws_instance_type
  key_name                    = aws_key_pair.my-key.key_name
  wait_for_fulfillment        = true
  subnet_id                   = aws_subnet.cluster-subnet.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.cluster-sg.id]

  root_block_device {
    volume_size           = var.aws_root_ebs_size
    volume_type           = var.aws_root_ebs_type
    delete_on_termination = true
  }

  provisioner "local-exec" {
    command = "aws ec2 create-tags --resources ${self.spot_instance_id} --tags Key=Name,Value=${each.value.node_name} --region ${var.aws_region}"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo hostnamectl set-hostname ${each.value.node_name}",
      "sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt clean all -y"
    ]

    on_failure = continue

    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = self.public_ip
      agent       = false
      private_key = file(pathexpand("~/.ssh/id_rsa"))
    }
  }

  tags = {
    "Name" = each.value.node_name
  }

}

resource "aws_key_pair" "my-key" {
  key_name   = "my-key"
  public_key = file("~/.ssh/id_rsa.pub")
}