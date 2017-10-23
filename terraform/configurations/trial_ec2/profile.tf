/** 共通 Instance Profile定義 */

module "common_ec2_role" {
  source = "./../../modules/role"

  name = "common-ec2"
  identifies = [
    "ec2.amazonaws.com"
  ]
}

resource "aws_iam_instance_profile" "common" {
  name = "common-ec2-profile"
  role = "${module.common_ec2_role.name}"
}

resource "aws_iam_role_policy" "common_ec2" {
  role = "${module.common_ec2_role.name}"
  policy = "${data.aws_iam_policy_document.common_ec2.json}"
}

data "aws_iam_policy_document" "common_ec2" {
  statement {
    effect = "Allow"
    actions = [
      "s3:Get*",
      "s3:List*"
    ],
    resources = [
      "arn:aws:s3:::biglobe-isp-build/",
      "arn:aws:s3:::biglobe-isp-build/*",
      "arn:aws:s3:::aws-codedeploy-ap-northeast-1/",
      "arn:aws:s3:::aws-codedeploy-ap-northeast-1/*"
    ]
  }
}
