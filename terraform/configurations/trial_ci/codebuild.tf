/** CodeBuild定義 */

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
