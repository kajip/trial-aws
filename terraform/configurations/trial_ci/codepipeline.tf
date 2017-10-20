/** CodePipeline定義 */

resource "aws_s3_bucket" "build" {
  bucket = "biglobe-isp-build"
  acl    = "private"
}

module "codepipeline_role" {
  source = "./../../modules/role"

  name = "codepipeline"
  identifies = [
    "codepipeline.amazonaws.com"
  ]
}

resource "aws_iam_role_policy" "codepipeline_role_policy" {
  role = "${module.codepipeline_role.name}"
  policy = "${data.aws_iam_policy_document.codepipeline_policy.json}"
}

data "aws_iam_policy_document" "codepipeline_policy" {
  statement {
    effect = "Allow"
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
  statement {
    effect = "Allow"
    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild"
    ]
    resources = [
      "*"
    ]
  }
}


resource "aws_codepipeline" "testing" {
  name     = "trial-testing-pipeline"
  role_arn = "${module.codepipeline_role.arn}"

  artifact_store {
    location = "${aws_s3_bucket.build.bucket}"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = [
        "test"
      ]

      configuration {
        Owner      = "tkajita"
        Repo       = "trial"
        Branch     = "master"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = [
        "test"
      ]
//      output_artifacts = [
//        "de"
//      ]
      version         = "1"

      configuration {
        ProjectName = "${aws_codebuild_project.trial.name}"
      }
    }
  }
}