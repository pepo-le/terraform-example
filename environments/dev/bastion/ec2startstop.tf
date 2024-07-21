module "iam_role_bastion_startstop" {
  source    = "../../../modules/iam_role"
  role_name = "foo-dev-bastion-startstop-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "scheduler.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

module "iam_policy_bastion_startstop" {
  source             = "../../../modules/iam_policy"
  policy_name        = "eventbridge-ec2-startstop-policy"
  policy_description = "eventbridge ec2 startstop policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "ec2:StartInstances",
          "ec2:StopInstances"
        ],
        Effect   = "Allow",
        Resource = "arn:aws:ec2:*"
      }
    ]
  })
}

module "iam_role_policy_attachment_bastion_startstop" {
  source     = "../../../modules/iam_role_policy_attachment"
  role_name  = module.iam_role_bastion_startstop.name
  policy_arn = module.iam_policy_bastion_startstop.arn
}

module "scheduler_ec2stop" {
  source                       = "../../../modules/eventbridge_scheduler"
  schedule_name                = "eventbridge-stop-scheduler"
  group_name                   = "default"
  schedule_expression          = "cron(53 12 * * ? *)"
  schedule_expression_timezone = "Asia/Tokyo"
  target_arn                   = "arn:aws:scheduler:::aws-sdk:ec2:stopInstances"
  role_arn                     = module.iam_role_bastion_startstop.arn
  input = jsonencode({
    InstanceIds = [module.ec2_instance.instance_id]
  })
}

module "scheduler_ec2start" {
  source                       = "../../../modules/eventbridge_scheduler"
  schedule_name                = "eventbridge-start-scheduler"
  group_name                   = "default"
  schedule_expression          = "cron(0 13 * * ? *)"
  schedule_expression_timezone = "Asia/Tokyo"
  target_arn                   = "arn:aws:scheduler:::aws-sdk:ec2:startInstances"
  role_arn                     = module.iam_role_bastion_startstop.arn
  input = jsonencode({
    InstanceIds = [module.ec2_instance.instance_id]
  })
}
