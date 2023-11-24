data "aws_subnet" "existing_subnet" {
  availability_zone_id = "use1-az6"
}

data "aws_security_group" "existing_sg" {
  name = "launch-wizard-2"
}

resource "tls_private_key" "algorithm" {
  algorithm = "RSA"
}

resource "local_file" "key_pair" {
  content  = tls_private_key.algorithm.private_key_pem
  filename = "${var.key_pair_name}.pem"
}

resource "aws_key_pair" "generated" {
  key_name   = var.key_pair_name
  public_key = tls_private_key.algorithm.public_key_openssh

  lifecycle {
    ignore_changes = [key_name]
  }
}

resource "aws_security_group_rule" "updating_rules" {
  type              = "ingress"
  count             = 2
  description       = var.sg_ingress_rules[count.index].description
  from_port         = var.sg_ingress_rules[count.index].from_port
  to_port           = var.sg_ingress_rules[count.index].to_port
  protocol          = var.sg_ingress_rules[count.index].protocol
  cidr_blocks       = ["${var.sg_ingress_rules[count.index].cidr_block}"]
  security_group_id = data.aws_security_group.existing_sg.id
}

resource "aws_instance" "jenkins_server" {
  ami                         = "ami-053b0d53c279acc90"
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.generated.key_name
  subnet_id                   = data.aws_subnet.existing_subnet.id
  vpc_security_group_ids      = ["${data.aws_security_group.existing_sg.id}"]
  associate_public_ip_address = true

  tags = {
    "Name" : "jenkins-server"
  }
}

resource "null_resource" "bootstraping_server" {
  connection {
    type        = "ssh"
    host        = aws_instance.jenkins_server.public_ip
    user        = "ubuntu"
    private_key = file("./${aws_key_pair.generated.key_name}.pem")
  }

  provisioner "remote-exec" {
    inline = [
      "echo jenkins installing process start ...",
      "sudo apt-get update -y",
      "curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null",
      "echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null",
      "sudo apt-get update -y",
      "sudo apt-get install fontconfig openjdk-11-jre -y",
      "sudo apt-get install jenkins -y",
      "echo jenkins install Done ...",
      "sudo apt install docker.io -y",
      "sudo usermod -aG docker jenkins",
      "sudo cat /var/lib/jenkins/secrets/initialAdminPassword",
    ]
  }

  provisioner "local-exec" {
    command = "aws ec2 reboot-instances --instance-ids ${aws_instance.jenkins_server.id}"
  }
}

