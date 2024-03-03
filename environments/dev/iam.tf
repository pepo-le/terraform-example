# IAMロールの作成
module "iam_role_ecs_task" {
  source    = "../../modules/iam_role"
  role_name = "foo-dev-task-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

module "iam_role_ecs_task_execution" {
  source    = "../../modules/iam_role"
  role_name = "foo-dev-task-execution-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# IAMポリシーの作成
module "iam_policy_s3" {
  source             = "../../modules/iam_policy"
  policy_name        = "foo-dev-s3-policy"
  policy_description = "foo dev s3 policy"
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
        Resource = "${module.s3_log.bucket_arn}/*"
      }
    ]
  })
}

module "iam_role_policy_attachment_s3" {
  source     = "../../modules/iam_role_policy_attachment"
  role_name  = module.iam_role_ecs_task.name
  policy_arn = module.iam_policy_s3.arn
}

module "iam_policy_ses" {
  source             = "../../modules/iam_policy"
  policy_name        = "foo-dev-ses-policy"
  policy_description = "foo dev ses policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "ses:SendEmail",
          "ses:SendRawEmail"
        ],
        Effect = "Allow",
        "Resource" : "*"
      }
    ]
  })
}

module "iam_role_policy_attachment_ses" {
  source     = "../../modules/iam_role_policy_attachment"
  role_name  = module.iam_role_ecs_task.name
  policy_arn = module.iam_policy_ses.arn
}

module "iam_policy_cwlogs" {
  source             = "../../modules/iam_policy"
  policy_name        = "foo-dev-cwlogs-policy"
  policy_description = "foo dev cwlogs policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams",
          "logs:PutLogEvents"

        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

module "iam_role_policy_attachment_cwlogs" {
  source     = "../../modules/iam_role_policy_attachment"
  role_name  = module.iam_role_ecs_task.name
  policy_arn = module.iam_policy_cwlogs.arn
}

module "iam_policy_parameter" {
  source             = "../../modules/iam_policy"
  policy_name        = "foo-dev-parameter-policy"
  policy_description = "foo dev parameter policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "ssm:GetParameters",
        ],
        Effect   = "Allow",
        Resource = [module.ssm_db_user.parameter_arn, module.ssm_db_password.parameter_arn]
      }
    ]
  })
}

module "iam_role_policy_attachment_ecs_parameter" {
  source     = "../../modules/iam_role_policy_attachment"
  role_name  = module.iam_role_ecs_task_execution.name
  policy_arn = module.iam_policy_parameter.arn
}

module "iam_role_policy_attachment_ecs_excecution" {
  source     = "../../modules/iam_role_policy_attachment"
  role_name  = module.iam_role_ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

module "iam_role_policy_attachment_ecs_ecr" {
  source     = "../../modules/iam_role_policy_attachment"
  role_name  = module.iam_role_ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
