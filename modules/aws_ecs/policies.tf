data "aws_iam_policy_document" "event" {
  count = var.create ? 1 : 0

  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "instance" {
  count = var.create ? 1 : 0

  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "service" {
  count = var.create ? 1 : 0

  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "event" {
  count              = var.create ? 1 : 0
  name               = "${var.project}-${terraform.workspace}-ecs-event-role"
  assume_role_policy = data.aws_iam_policy_document.event[0].json
}

resource "aws_iam_role" "instance" {
  count              = var.create ? 1 : 0
  name               = "${var.project}-${terraform.workspace}-ecs-instance-role"
  assume_role_policy = data.aws_iam_policy_document.instance[0].json
}

resource "aws_iam_role" "service" {
  count              = var.create ? 1 : 0
  name               = "${var.project}-${terraform.workspace}-ecs-service-role"
  assume_role_policy = data.aws_iam_policy_document.service[0].json
}

data "aws_iam_policy_document" "event_policy" {
  count = var.create ? 1 : 0

  statement {
    actions = [
      "ecs:RunTask"
    ]

    resources = [
      "*"
    ]
  }
}

data "aws_iam_policy_document" "instance_policy" {
  count = var.create ? 1 : 0

  statement {
    actions = [
      "ecs:CreateCluster",
      "ecs:DeregisterContainerInstance",
      "ecs:DiscoverPollEndpoint",
      "ecs:Poll",
      "ecs:RegisterContainerInstance",
      "ecs:StartTelemetrySession",
      "ecs:UpdateContainerInstancesState",
      "ecs:Submit*",
      #      "ecr:GetAuthorizationToken",
      #      "ecr:BatchCheckLayerAvailability",
      #      "ecr:GetDownloadUrlForLayer",
      #      "ecr:BatchGetImage",
      "logs:List*",
      "logs:DescribeLogGroups",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "ssm:DescribeAssociation",
      "ssm:GetDeployablePatchSnapshotForInstance",
      "ssm:GetDocument",
      "ssm:DescribeDocument",
      "ssm:GetManifest",
      "ssm:GetParameter",
      "ssm:GetParameters",
      "ssm:ListAssociations",
      "ssm:ListInstanceAssociations",
      "ssm:PutInventory",
      "ssm:PutComplianceItems",
      "ssm:PutConfigurePackageResult",
      "ssm:UpdateAssociationStatus",
      "ssm:UpdateInstanceAssociationStatus",
      "ssm:UpdateInstanceInformation",
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel",
      "ec2messages:AcknowledgeMessage",
      "ec2messages:DeleteMessage",
      "ec2messages:FailMessage",
      "ec2messages:GetEndpoint",
      "ec2messages:GetMessages",
      "ec2messages:SendReply",
      "cloudwatch:PutMetricData",
      "ec2:DescribeVolumes",
      "ec2:DescribeTags"
    ]

    resources = [
      "*"
    ]
  }
}

data "aws_iam_policy_document" "service_policy" {
  count = var.create ? 1 : 0

  statement {
    actions = [
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:Describe*",
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:Describe*",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "elasticloadbalancing:RegisterTargets",
    ]

    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role_policy" "event_policy" {
  count  = var.create ? 1 : 0
  name   = "${var.project}-${terraform.workspace}-ecs-event-policy"
  role   = aws_iam_role.event[0].id
  policy = data.aws_iam_policy_document.event_policy[0].json
}

resource "aws_iam_role_policy" "service_policy" {
  count  = var.create ? 1 : 0
  name   = "${var.project}-${terraform.workspace}-ecs-service-policy"
  role   = aws_iam_role.service[0].id
  policy = data.aws_iam_policy_document.service_policy[0].json
}

resource "aws_iam_role_policy" "instance_policy" {
  count  = var.create ? 1 : 0
  name   = "${var.project}-${terraform.workspace}-ecs-instance-policy"
  role   = aws_iam_role.instance[0].id
  policy = data.aws_iam_policy_document.instance_policy[0].json
}

resource "aws_iam_instance_profile" "instance" {
  count = var.create ? 1 : 0
  name  = "${var.project}-${terraform.workspace}-instance-profile"
  role  = aws_iam_role.instance[0].name
}


