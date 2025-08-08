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
  # The thumbprint_list must be up-to-date. These are the current values for GitHub.
  # The first thumbprint is the primary; the second is a backup.
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1", "1c58a3a8518e8759bf075b76b750d4f2df264fcd"]
}


# The IAM role that GitHub Actions will assume.
# The `assume_role_policy` is the most important part, defining who can assume the role.
resource "aws_iam_role" "github_actions_api_access_role" {
  name = "GithubActions"

  # The trust policy for the role.
  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          # This specifies the OIDC provider we just created.
          "Federated" : aws_iam_openid_connect_provider.github_actions_oidc.arn
        },
        "Action" : "sts:AssumeRoleWithWebIdentity",
        "Condition" : {
          # The `aud` (audience) claim must be sts.amazonaws.com for the token
          # to be considered valid for assuming an AWS role.
          "StringEquals" : {
            "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
          },
          # The `sub` (subject) claim identifies the repository and branch.
          # We use StringLike here to allow any branch to assume the role,
          # as long as it's from your specified repository.
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