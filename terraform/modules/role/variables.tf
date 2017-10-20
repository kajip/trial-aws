/** 変数定義 */

variable "name" {
  description = "ロール名"
}

variable "identifies" {
  type = "list"
  description = "ロールプリンシパルのURL"
}
