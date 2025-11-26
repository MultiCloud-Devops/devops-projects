#-----------------------------
# IAM Role for NLB
#-----------------------------
data "aws_iam_policy_document" "instance_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}


#-----------------------------
# IAM Policy Document for Lifecycle Actions
#----------------------------
data "aws_iam_policy_document" "lifecycle_policy_action" {
  statement {
    actions = [
      "autoscaling:CompleteLifecycleAction",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLifecycleHooks",
      "autoscaling:DescribeAutoScalingGroups"
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role" "tfsp_be_instance_role" {
  name               = "tfsp-${var.envname}-be-instance-role"
  assume_role_policy = data.aws_iam_policy_document.instance_assume_role_policy.json
}

resource "aws_iam_policy" "tfsp_be_asg_lifecycle_hook_policy" {
  name   = "tfsp-${var.envname}-be-asg-lifecycle-hook-policy"
  policy = data.aws_iam_policy_document.lifecycle_policy_action.json

}

#-----------------------------
# IAM Role Policy Attachment
#-----------------------------
resource "aws_iam_policy_attachment" "tfsp_s3_attach" {
  name       = "tfsp-${var.envname}-s3-access-policy"
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  roles      = [aws_iam_role.tfsp_be_instance_role.name]
}



resource "aws_iam_policy_attachment" "tfsp_cloud_watch_agent_attach" {
  roles      = [aws_iam_role.tfsp_be_instance_role.name]
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  name       = "tfsp-${var.envname}-cloud-watch-agent-policy"
}

resource "aws_iam_policy_attachment" "tfsp_asg_lifecycle_hook_attach" {
  name       = "tfsp-${var.envname}-be-asg-lifecycle-hook-policy-attachment"
  policy_arn = aws_iam_policy.tfsp_be_asg_lifecycle_hook_policy.arn
  roles      = [aws_iam_role.tfsp_be_instance_role.name]

}