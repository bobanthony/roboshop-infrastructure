resource "aws_instance" "ec2" {
  ami                    = "ami-0a017d8ceb274537d"
  instance_type          = "t3.micro"
  vpc_security_group_ids = [var.component]
  tags = {
    name = "var.component"
  }
}

resource "null_resource" "provisioner" {
  provisioner "remote-exec" {

    connection {
      host = aws_instance.ec2.public_ip
      user = "centos"
      password = "DevOps321"
    }

    inline = [
      "git clone https://github.com/bobanthony/roboshop-shell",
      "cd roboshop-shell",
      "sudo bash ${var.component}.sh"
    ]
  }
}
resource "aws_security_group" "sg" {
  name        = "${var.component}-${var.env}-sg"
  description = "Allow TLS inbound traffic"


  ingress {
    description      = "ALL"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]

  }
  tags = {
    Name = "${var.component}-${var.env}-sg"
  }
}




resource "aws_route53_record" "record" {
  zone_id = "Z00739661SEOHEMKPHEUL"
  name    = "${var.component}-dev.learndevopsb71solutions.site"
  type    = "A"
  ttl     = 300
  records = [aws_instance.ec2.private_ip]
}
variable "component" {}
variable "instance_type" {}

variable "env" {}
