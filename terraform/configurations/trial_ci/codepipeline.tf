/** CodePipeline定義 */

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
      name             = "Source@GitHub"
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
      name            = "Deploy@Trial"
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