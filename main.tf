locals {
  ssh_private_key_file = "./ssh/id_rsa"
}

provider "aws" {
  region     = var.region
}

resource "local_file" "ssh_key" {
  count    = var.ssh_private_key == "FROM_FILE" ? 0 : 1
  content  = var.ssh_private_key
  filename = "./ssh/temp_key"
}

resource "null_resource" "fix_key" {
  count      = var.ssh_private_key == "FROM_FILE" ? 0 : 1
  depends_on = [local_file.ssh_key]
  provisioner "local-exec" {
    command = "(HF=$(cat ./ssh/temp_key | cut -d' ' -f2-4);echo '-----BEGIN '$HF;cat ./ssh/temp_key | sed -e 's/--.*-- //' -e 's/--.*--//' | awk '{for (i = 1; i <= NF; i++) print $i}';echo '-----END '$HF) > ${local.ssh_private_key_file}"
  }
}

resource "null_resource" "name" {
  provisioner "local-exec" {
    command = "ls -l ./ssh"
    }
  }

data "null_data_source" "values" {
  inputs = {
    vpc_id = var.vpc_id
    }
}

#install mysql

resource "aws_instance" "mysql1" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet
  vpc_security_group_ids = var.sg
  key_name               = var.key

connection {
        host	= var.remote_host
        type     = "ssh"
        user     = "ubuntu"
        private_key = "${file(local.ssh_private_key_file)}"
        timeout  = "20m"
}
  
provisioner "file" {
  source      = "./scripts/script.sh"
  destination = "/tmp/script.sh"
}

provisioner "remote-exec" {
  inline = [
    "sudo chmod +x /tmp/script.sh",
    "sudo /tmp/script.sh "
  ]
}

  provisioner "remote-exec" {
      inline = [
        "sudo sh -c 'echo ${self.public_ip}  >> /etc/ansible/hosts'",
        "sudo ansible-playbook /etc/ansible/playbooks/install_multi_scalr/initial_setup.yml --limit ${self.public_ip} --verbose",
        "sudo ansible-playbook /etc/ansible/playbooks/install_multi_scalr/install_mysql_local.yml --limit ${self.public_ip} --verbose"
      ]
  }

}

#install worker

resource "aws_instance" "worker" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.subnet
  vpc_security_group_ids = var.sg
  key_name               = var.key

connection {
        host	= var.remote_host
        type     = "ssh"
        user     = "ubuntu"
        private_key = "${file(local.ssh_private_key_file)}"
        timeout  = "20m"
}
  
provisioner "file" {
  source      = "./scripts/script.sh"
  destination = "/tmp/script.sh"
}

provisioner "remote-exec" {
  inline = [
    "sudo chmod +x /tmp/script.sh",
    "sudo /tmp/script.sh "
  ]
}

  provisioner "remote-exec" {
      inline = [
        "sudo sh -c 'echo ${self.public_ip}  >> /etc/ansible/hosts'",
        "sudo ansible-playbook /etc/ansible/playbooks/install_multi_scalr/initial_setup.yml --limit ${self.public_ip} --verbose",
        "sudo ansible-playbook /etc/ansible/playbooks/install_multi_scalr/install_worker_local.yml --limit ${self.public_ip} --verbose"
      ]
  }

}

resource "null_resource" "create_config" {
  
  connection {
        host	= aws_instance.mysql1.public_ip
        type     = "ssh"
        user     = "ubuntu"
        private_key = "${file(local.ssh_private_key_file)}"
        timeout  = "20m"
  }

  provisioner "file" {
      source = "./SCRIPTS/scalr_install_set_config.sh"
      destination = "/var/tmp/scalr_install_set_config.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /var/tmp/scalr_install_set_config.sh",
      "/var/tmp/scalr_install_set_config.sh ${aws_instance.worker.private_ip}",
    ]
  }

}
