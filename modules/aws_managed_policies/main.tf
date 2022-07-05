data "aws_caller_identity" "current" {}

resource "aws_iam_group" "iam_group" {
  name = var.group_name
}

resource "aws_iam_group_policy_attachment" "managed_policy_attachments" {
  count      = length(var.managed_policies)
  group      = aws_iam_group.iam_group.name
  policy_arn = "arn:aws:iam::aws:policy/${var.managed_policies[count.index]}"
}

resource "aws_iam_group_policy_attachment" "custom_policy_attachments" {
  count      = length(var.custom_policies)
  group      = aws_iam_group.iam_group.name
  policy_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:policy/${var.custom_policies[count.index]}"
}
