/** S3定義 */

resource "aws_s3_bucket" "build" {
  bucket = "biglobe-isp-build"
  acl    = "private"
}
