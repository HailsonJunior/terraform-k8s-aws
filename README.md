# Terraform k8s AWS 

This is a project to deploy a Kubernetes cluster on
[AWS](https://aws.amazon.com/pt/) using Terraform.

Terraform files by default, deploy 4 spot instances ([which can get up to 90% off](https://aws.amazon.com/pt/ec2/spot)). Each machine
has 2 vCPUs and 4 GiB of RAM (instance type is c5.large).

**It is not meant to run production workloads,**
but you can use it to learn Kubernetes with a cluster with multiple nodes.

## Getting started

If you are using Ubuntu Linux you can use the ```install.sh``` script for dependencies instalation of follow the instructions bellow.

1. Create an AWS account ([this link](https://aws.amazon.com/pt/resources/create-account/)).
2. Have installed or [install kubernetes](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/#installing-kubeadm-kubelet-and-kubectl).
3. Have installed or [install terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/oci-get-started).
4. Have installed or [install AWS CLI ](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).
5. Configure [AWS credentials](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html).
6. Download this project and enter its folder `git clone https://github.com/HailsonJunior/terraform-k8s-aws.git && cd terraform-k8s-aws/`.
7. `terraform init`
8. `terraform apply`
9. Export kubeconfig variable

Linux
```bash
export KUBECONFIG=$PWD/kubeconfig
kubectl get nodes
```

Windows
```powershell
$env:KUBECONFIG="$pwd\kubeconfig"
kubectl get nodes
```

That's it!

You can also log into the VMs with the commands at the end of the Terraform output. Copy and paste the command.

## Windows

It works with Windows 10/Powershell 5.1.

It may be necesssary to change the execution policy to unrestricted.

[PowerShell ExecutionPolicy](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.security/set-executionpolicy?view=powershell-5.1)

## Customization

You can change the values on `variables.tf` for customization.

## Destroy the cluster

`terraform destroy`

## Remarks

AWS also has a managed Kubernetes service called
[EKS](https://aws.amazon.com/pt/eks/), you can use it instead, but it's more expensive than spot instances.

## References

This project was made based on [ampernetacle](https://github.com/jpetazzo/ampernetacle) project that has the same purpose but on Oracle Cloud.
