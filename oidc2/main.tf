resource "aws_iam_openid_connect_provider" "github_actions_oidc" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1", "1c58a3a8518e8759bf075b76b750d4f2df264fcd"]
}

resource "aws_iam_role" "githubactions_oidc_role" {
  name = var.role_name
  assume_role_policy = templatefile(
    "${path.module}/templates/githubactions.json",
    {
      github_provider_arn = aws_iam_openid_connect_provider.github_actions_oidc.arn
      owner = var.owner
      repository = var.repository
    }
  )
}

resource "aws_iam_role_policy" "github_actions_access_policy" {
  name = "github-actions-access-policy"
  role = aws_iam_role.githubactions_oidc_role.id
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