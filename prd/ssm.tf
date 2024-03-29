resource "aws_ssm_activation" "main_activation" {
  name               = "main_ssm_activation"
  iam_role           = aws_iam_role.ec2-role.id
  registration_limit = "5"
  depends_on         = [aws_iam_role_policy_attachment.ec2-ssm-role-attachment]
}
