resource "aws_iam_user" "iam_user" {
  count = var.user != "" ? 1 : 0
  name  = "${var.project}-${terraform.workspace}-user-${var.user}"
}

resource "aws_iam_user_group_membership" "members" {
  count = var.user != "" ? 1 : 0
  user  = "${var.project}-${terraform.workspace}-user-${var.user}"

  groups = var.groups

  depends_on = [aws_iam_user.iam_user]
}
