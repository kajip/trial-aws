/** VPC Security Group 定義 */

// Default VPC の取得
resource "aws_default_vpc" "default" {
}

// Default Security Group の取得
resource "aws_default_security_group" "default" {
  vpc_id = "${aws_default_vpc.default.id}"

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}

// SSH用のSecurity Group
resource "aws_security_group" "allow_ssh" {
  name = "trial-allow-ssh"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = "${var.allow_cidr_addrs}"
  }

  tags {
    Name = "sg-trial-allow-ssh"
  }
}

// HTTP用のSecurity Group
resource "aws_security_group" "allow_http" {
  name = "trial-allow-http"
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = "${var.allow_cidr_addrs}"
  }

  tags {
    Name = "sg-trial-allow-http"
  }
}

// HTTP用のSecurity Group
resource "aws_security_group" "allow_tomcat" {
  name = "trial-allow-tomcat"
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = "${var.allow_cidr_addrs}"
  }

  tags {
    Name = "sg-trial-allow-tomcat"
  }
}
