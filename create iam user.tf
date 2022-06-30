module "iam_iam-user" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "5.1.0"
 
 name = "terraform_only_user"
 
 create_iam_access_key = true
 create_iam_user_login_profile = false


}