variable "aws_region" {
  description = "Region where resources will be created"
  type        = string
  default     = "us-east-2"
}

variable "how_many_nodes" {
  description = "Number of nodes"
  type        = number
  default     = 4
}

variable "aws_ami" {
  description = "AMI for instances"
  type        = string
  default     = "ami-0eea504f45ef7a8f7"
}

variable "aws_instance_type" {
  type    = string
  default = "c5.large"
}

variable "aws_root_ebs_size" {
  description = "EBS block storage size"
  type        = number
  default     = 8
}

variable "aws_root_ebs_type" {
  description = "EBS block storage type"
  type        = string
  default     = "gp2"
}