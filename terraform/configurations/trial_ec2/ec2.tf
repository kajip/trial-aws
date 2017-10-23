/** EC2 Instance 定義 */

// EC2 インスタンス
resource "aws_instance" "trial" {
  ami = "${var.ami_id}"
  instance_type = "t2.micro"
  iam_instance_profile = "${aws_iam_instance_profile.common.name}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = [
    "${aws_default_security_group.default.id}",
    "${aws_security_group.allow_ssh.id}",
    "${aws_security_group.allow_http.id}"
  ]
  user_data = <<EOF
#cloud-config
locale: ja_JP.UTF-8
timezone: Asia/Tokyo

repo_upgrade: none
EOF
  tags {
    Name = "trial"
    Environment = "Trial"
  }
}

resource "aws_default_vpc" "default" {
}

resource "aws_default_security_group" "default" {
  vpc_id = "${aws_default_vpc.default.id}"
}

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

resource "aws_security_group" "allow_http" {
  name = "trial-allow-http"
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = "${var.allow_cidr_addrs}"
  }

  tags {
    Name = "sg-trial-allow-http"
  }
}
