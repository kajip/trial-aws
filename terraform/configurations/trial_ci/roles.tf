/** Role定義 */

// CodeBuild
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


// CodeDeploy
module "codedeploy_role" {
  source = "./../../modules/role"

  name = "codedeploy"
  identifies = [
    "codedeploy.amazonaws.com"
  ]
}

resource "aws_iam_role_policy_attachment" "codedeploy_role_policy" {
  role = "${module.codedeploy_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
}


// CodePipeline
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
  // たぶん、もう少し絞り込めそう...
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
