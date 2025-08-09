######################################################################
# OIDC to enable communication between GitHub >> AWS without secrets
# This configuration creates the OIDC provider, the IAM role, and the
# policy required for GitHub Actions to assume the role.
######################################################################

# The OIDC provider resource. This is a crucial step that establishes trust
# between AWS and GitHub's OIDC service.
resource "aws_iam_openid_connect_provider" "github_actions_oidc" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1", "1c58a3a8518e8759bf075b76b750d4f2df264fcd"]
}

resource "aws_iam_role" "GithubActionsRole" {
  name = "GithubActionsRole"

  # The trust policy for the role.
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
          "StringEquals" : {
            "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
          },
          "StringLike" : {
            "token.actions.githubusercontent.com:sub": "repo:getdzidon/jomacs-q1:*"
          }
        }
      }
    ]
  })
}


# The IAM policy that grants permissions to the assumed role.
# This policy is attached to the role created above.
# The current policy is wide open ("*"), which is fine for initial testing,
# but should be restricted in a production environment.
resource "aws_iam_role_policy" "github_actions_access_policy" {
  name = "github-actions-access-policy"
  role = aws_iam_role.GithubActionsRole.id
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