/** 出力定義 */

output "public_ip" {
  value = "${aws_instance.trial.public_ip}"
}
