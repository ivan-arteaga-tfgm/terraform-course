#-------------------------------------------------------------------------------------------------
resource "aws_iam_role" "iam-role-codepipeline" {
  name = "${local.default_name}-iam-role-codepipeline"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

}
#-------------------------------------------------------------------------------------------------
data "aws_iam_policy_document" "iam-policy-document-codepipeline-role-policy" {
  statement {
    effect = "Allow"
    actions = [
      "s3:*",
    ]
    resources = [
      aws_s3_bucket.s3-bucket-artifacts.arn,
      "${aws_s3_bucket.s3-bucket-artifacts.arn}/*",
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild",
    ]
    resources = [
      "*",
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "sts:AssumeRole",
    ]
    resources = [
      "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.default_name}-iam-role-codepipeline",
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "kms:DescribeKey",
      "kms:GenerateDataKey*",
      "kms:Encrypt",
      "kms:ReEncrypt*",
      "kms:Decrypt",
    ]
    resources = [
      aws_kms_key.kms-key.arn,
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "codecommit:UploadArchive",
      "codecommit:Get*",
      "codecommit:BatchGet*",
      "codecommit:Describe*",
      "codecommit:BatchDescribe*",
      "codecommit:GitPull",
    ]
    resources = [
      aws_codecommit_repository.codecommit-repo.arn,
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "codedeploy:*",
      "ecs:*",
    ]
    resources = [
      "*",
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "iam:PassRole"
    ]
    resources = [
      aws_iam_role.iam-role-ecs-task-execution-role.arn,
      aws_iam_role.iam-role-ecs-task-role.arn,
    ]
    condition {
      test     = "StringLike"
      variable = "iam:PassedToService"
      values   = ["ecs-tasks.amazonaws.com"]
    }
  }
}
#-------------------------------------------------------------------------------------------------
resource "aws_iam_role_policy" "iam-role-policy-codepipeline" {
  name   = "${local.default_name}-iam-role-policy-codepipeline"
  role   = aws_iam_role.iam-role-codepipeline.id
  policy = data.aws_iam_policy_document.iam-policy-document-codepipeline-role-policy.json
}
#-------------------------------------------------------------------------------------------------

