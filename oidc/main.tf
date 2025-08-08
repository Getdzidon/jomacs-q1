######################################################################
# OIDC to enable communication between GitHub >> AWS without secrets
# Resource can be found under IAM >> Identity providers
######################################################################

resource "aws_iam_openid_connect_provider" "github_actions_oidc" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}


resource "aws_iam_role" "github_actions_api_access_role" {
  name = "GithubActions"
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : aws_iam_openid_connect_provider.github_actions_oidc.arn
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          "StringLike" : {
            "token.actions.githubusercontent.com:sub": "repo:getdzidon/jomacs-q1:ref:refs/heads/main"
            },
          "StringEquals": {
                    "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
          }
        }
      }
    ]
  })
}


resource "aws_iam_role_policy" "github_actions_access_policy" {
  name = "github-actions-access-policy"
  role = aws_iam_role.github_actions_api_access_role.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "*",
        "Resource" : "*",
        "Effect" : "Allow"
      }
    ]
  })
}