variable "region" {
  description = "Region"
}

variable "instance_type" {
  description = "Instance Type"
}

variable "subnet" {
description = "Subnet ID"
}

variable "sg" {
  description = "AWS Secruity Group"
  type        = list(string)
}

variable "key" {
  description = "AWS Key"
}

variable "vpc_id" {
description = "VPC"
}

variable "ami" {
  description = "AMI"
}

variable "remote_host" {
  description = "Ansible Host"
}

variable "ssh_private_key" {
  description = "The text of SSH Private key. This will be formatted by the Terraform template.<br>This will be used in the remote workspace to allow Terraform to connect to the servers and run scripts to configure Scalr. It only exists in the workspace for the duration of the run."
  type = string
  default = "FROM_FILE"
}
