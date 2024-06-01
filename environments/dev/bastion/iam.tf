module "iam_role_bastion" {
  source    = "../../../modules/iam_role"
  role_name = "foo-dev-bastion-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# IAMポリシーの作成
module "iam_policy_bastion_s3_images" {
  source             = "../../../modules/iam_policy"
  policy_name        = "foo-dev-bastion-s3-images-policy"
  policy_description = "foo dev bastion-s3 images policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ],
        Effect   = "Allow",
        Resource = "${data.terraform_remote_state.common.outputs.s3_images_bucket_arn}/*"
      }
    ]
  })
}

module "iam_role_policy_attachment_bastion_s3_images" {
  source     = "../../../modules/iam_role_policy_attachment"
  role_name  = module.iam_role_bastion.name
  policy_arn = module.iam_policy_bastion_s3_images.arn
}
