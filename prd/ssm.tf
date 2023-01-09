resource "aws_ssm_activation" "foo" {
  name               = "test_ssm_activation"
  description        = "Test"
  iam_role           = aws_iam_role.ssm_role.id
  registration_limit = "5"
  depends_on         = [aws_iam_role_policy_attachment.SSM-role-policy-attach]
}
