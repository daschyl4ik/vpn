module "iam_iam-group-with-policies" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-group-with-policies"
  version = "5.1.0"

  create_group = true
  name = "terraform_user_group"
  group_users = ["terraform_only_user"]

  custom_group_policy_arns = ["arn:aws:iam::aws:policy/AmazonEC2FullAccess","arn:aws:iam::aws:policy/AmazonVPCFullAccess"]

 attach_iam_self_management_policy = false
 
}