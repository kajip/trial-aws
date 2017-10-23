/** CodePipeline定義 */

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
  statement {
    effect = "Allow"
    actions = [
      "codedeploy:*"
    ]
    resources = [
      "*"
    ]
  }
}


resource "aws_codepipeline" "testing" {
  name     = "${var.pipeline_name}"
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
        "${var.source_artifacts}"
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
        "${var.source_artifacts}"
      ]
      output_artifacts = [
        "${var.distribution_artifacts}"
      ]
      version         = "1"

      configuration {
        ProjectName = "${aws_codebuild_project.trial.name}"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Release@Trial"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      input_artifacts = [
        "${var.distribution_artifacts}"
      ]
      version         = "1"

      configuration {
        ApplicationName = "${aws_codedeploy_app.trial.name}"
        DeploymentGroupName = "${aws_codedeploy_deployment_group.trial.deployment_group_name}"
      }
    }
  }
}