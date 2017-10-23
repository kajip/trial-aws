
resource "aws_codedeploy_app" "trial" {
  name = "trial"
}

resource "aws_codedeploy_deployment_config" "trial" {
  deployment_config_name = "test-deployment-config"

  minimum_healthy_hosts {
    type  = "HOST_COUNT"
    value = 1
  }
}

resource "aws_codedeploy_deployment_group" "trial" {
  deployment_group_name  = "trial"
  app_name               = "${aws_codedeploy_app.trial.name}"
  deployment_config_name = "${aws_codedeploy_deployment_config.trial.id}"
  service_role_arn       = "${aws_iam_role.foo_role.arn}"

  ec2_tag_filter {
    key   = "filterkey"
    type  = "KEY_AND_VALUE"
    value = "filtervalue"
  }

  trigger_configuration {
    trigger_events     = ["DeploymentFailure"]
    trigger_name       = "foo-trigger"
    trigger_target_arn = "foo-topic-arn"
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  alarm_configuration {
    alarms  = ["my-alarm-name"]
    enabled = true
  }
}