resource "aws_ses_email_identity" "michka-ses" {
  email = "michkapopoff@gmail.com"
}

resource "aws_iam_user" "smtp-user" {
  name = "smtp-user"
}

resource "aws_iam_access_key" "smtp-user" {
  user = aws_iam_user.smtp-user.name
}

data "aws_iam_policy_document" "ses-sender-policy-document" {
  statement {
    actions   = ["ses:SendRawEmail"]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ses-sender-policy" {
  name        = "ses-sender"
  description = "Allows sending of e-mails via Simple Email Service"
  policy      = data.aws_iam_policy_document.ses-sender-policy-document.json
}

resource "aws_iam_user_policy_attachment" "smtp-iam-user-attachment" {
  user       = aws_iam_user.smtp-user.name
  policy_arn = aws_iam_policy.ses-sender-policy.arn
}

output "smtp-username" {
  value = aws_iam_access_key.smtp-user.id
}

output "smtp_password" {
  value     = aws_iam_access_key.smtp-user.ses_smtp_password_v4
  sensitive = true
}
