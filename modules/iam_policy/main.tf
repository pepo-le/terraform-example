resource "aws_iam_policy" "main" {
  name        = var.policy_name
  description = var.policy_description
  policy      = var.policy
}
