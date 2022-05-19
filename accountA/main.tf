resource "aws_organizations_organization" "root" {
  enabled_policy_types = [
    "SERVICE_CONTROL_POLICY",
  ]
  feature_set = "ALL"
}

resource "aws_organizations_organizational_unit" "dev_ou" {
  name      = "dev_ou"
  parent_id = aws_organizations_organization.root.roots[0].id
}

resource "aws_organizations_account" "AccountA" {
  name      = "AccountA"
  email     = "no@thanks.com"
  parent_id = aws_organizations_organizational_unit.dev_ou.id
}

resource "aws_organizations_policy" "BlockExpensiveInstances" {
  name = "BlockExpensiveInstances"

  content = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : {
        "Effect" : "Deny",
        "Action" : [
          "ec2:RunInstances",
          "ec2:LaunchInstances",
          "ec2:StartInstances",
        ],
        "Resource" : "arn:aws:ec2:*:*:instance/*",
        "Condition" : {
          "StringNotLike" : {
            "ec2:InstanceType" : "t2.*"
          }
        }
      }
    }
  )
}

resource "aws_organizations_policy_attachment" "AttachBlockExpensiveInstances" {
  policy_id = aws_organizations_policy.BlockExpensiveInstances.id
  target_id = aws_organizations_organizational_unit.dev_ou.id
}
