/** 変数定義 */

variable "ami_id" {
  description = "AMI ID"
}

variable "key_name" {
  description = "SSH Key Name"
}

variable "allow_cidr_addrs" {
  type = "list"
  description = "Access Allowed CIDR Address"
}
