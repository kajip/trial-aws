/** Remote Backendsの定義 */

terraform {
  backend "s3" {
    bucket = "biglobe-isp-terraform-bucket"
    key    = "trial_ec2/terraform.tfstate"
    region = "ap-northeast-1"
  }
}
