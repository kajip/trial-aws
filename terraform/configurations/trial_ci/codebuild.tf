/** CodeBuild定義 */

module "codebuild_role" {
  source = "./../../modules/role"

  name = "codebuild"
  identifies = [
    "codebuild.amazonaws.com"
  ]
}

resource "aws_iam_role_policy" "codebuild_role_policy" {
  role = "${module.codebuild_role.name}"
  policy = "${data.aws_iam_policy_document.codebuild_policy.json}"
}

data "aws_iam_policy_document" "codebuild_policy" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "*"
    ]
  }
  statement {
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObject"
    ]
    resources = [
      "${aws_s3_bucket.build.arn}",
      "${aws_s3_bucket.build.arn}/*"
    ]
  }
}

resource "aws_codebuild_project" "trial" {
  name          = "${var.build_project_name}"
  description   = "Trial Build Project"
  build_timeout = "${var.build_timeout}"
  service_role = "${module.codebuild_role.arn}"

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/eb-java-8-amazonlinux-64:2.1.6"
    type         = "LINUX_CONTAINER"
  }

  source {
    type = "CODEPIPELINE"
  }

  artifacts {
    type = "CODEPIPELINE"
  }

  tags {
    "Environment" = "Test"
  }
}
