/** EC2 Instance 定義 */

// EC2 インスタンス
resource "aws_instance" "trial01" {

  ami = "${var.ami_id}"
  instance_type = "t2.micro"
  subnet_id = "${var.subnet_id_a}"
  iam_instance_profile = "${aws_iam_instance_profile.common.name}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = [
    "${aws_default_security_group.default.id}",
    "${aws_security_group.allow_ssh.id}",
    "${aws_security_group.allow_tomcat.id}"
  ]
  user_data = <<EOF
#cloud-config
locale: ja_JP.UTF-8
timezone: Asia/Tokyo

repo_upgrade: none
EOF
  tags {
    Name = "trial01"
    Environment = "Trial"
  }
}

resource "aws_lb_target_group_attachment" "trial01" {
  target_group_arn = "${aws_lb_target_group.trial.id}"
  target_id        = "${aws_instance.trial01.id}"
}

// EC2 インスタンス
resource "aws_instance" "trial02" {

  ami = "${var.ami_id}"
  instance_type = "t2.micro"
  subnet_id = "${var.subnet_id_c}"
  iam_instance_profile = "${aws_iam_instance_profile.common.name}"
  key_name = "${var.key_name}"
  vpc_security_group_ids = [
    "${aws_default_security_group.default.id}",
    "${aws_security_group.allow_ssh.id}",
    "${aws_security_group.allow_tomcat.id}"
  ]
  user_data = <<EOF
#cloud-config
locale: ja_JP.UTF-8
timezone: Asia/Tokyo

repo_upgrade: none
EOF
  tags {
    Name = "trial02"
    Environment = "Trial"
  }
}

resource "aws_lb_target_group_attachment" "trial02" {
  target_group_arn = "${aws_lb_target_group.trial.id}"
  target_id        = "${aws_instance.trial02.id}"
}
