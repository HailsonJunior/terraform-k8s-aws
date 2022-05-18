locals {
  nodes = {
    for i in range(1, 1 + var.how_many_nodes) :
    i => {
      node_name  = i == 1 ? format("k8s-master%d", i) : format("k8s-worker%d", i - 1)
      ip_address = format("10.0.80.%d", 10 + i)
      role       = i == 1 ? "controlplane" : "worker"
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
  private_ip                  = each.value.ip_address
  vpc_security_group_ids      = [aws_security_group.cluster-sg.id]
  user_data                   = data.cloudinit_config._[each.key].rendered

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
      "sudo hostnamectl set-hostname ${each.value.node_name}"
    ]

    on_failure = continue

    connection {
      type        = "ssh"
      user        = "ubuntu"
      host        = self.public_ip
      agent       = false
      private_key = local_file.ssh_private_key.filename
    }
  }
}

resource "aws_key_pair" "my-key" {
  key_name   = "my-key"
  public_key = join("\n", local.authorized_keys)
}