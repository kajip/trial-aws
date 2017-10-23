/** 出力定義 */

output "trial01_public_ip" {
  value = "${aws_instance.trial01.public_ip}"
}

output "trial02_public_ip" {
  value = "${aws_instance.trial02.public_ip}"
}
