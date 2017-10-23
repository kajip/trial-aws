/** 変数定義 */

variable "ami_id" {
  description = "AMI ID"
}

variable "key_name" {
  description = "SSH Key Name"
}

variable "subnet_id_a" {
  default = "subnet-61fc5216"
}

variable "subnet_id_c" {
  default = "subnet-04bc7c5d"
}

variable "allow_cidr_addrs" {
  type = "list"
  description = "Access Allowed CIDR Address"
}
