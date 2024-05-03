output "iam_role_ecs_task_role_name" {
  value = module.iam_role_ecs_task.name
}

output "iam_role_ecs_task_role_arn" {
  value = module.iam_role_ecs_task.arn
}

output "iam_role_ecs_task_exec_role_name" {
  value = module.iam_role_ecs_task_exec.name
}

output "iam_role_ecs_task_exec_role_arn" {
  value = module.iam_role_ecs_task_exec.arn
}

# IAMロールの作成
module "iam_role_ecs_task" {
  source    = "../../../modules/iam_role"
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

module "iam_role_ecs_task_exec" {
  source    = "../../../modules/iam_role"
  role_name = "foo-dev-task-exec-role"
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
module "iam_policy_s3_images" {
  source             = "../../../modules/iam_policy"
  policy_name        = "foo-dev-s3-images-policy"
  policy_description = "foo dev s3 images policy"
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
        Resource = "${module.s3_images.bucket_arn}/*"
      }
    ]
  })
}

module "iam_role_policy_attachment_ecs_s3_images" {
  source     = "../../../modules/iam_role_policy_attachment"
  role_name  = module.iam_role_ecs_task.name
  policy_arn = module.iam_policy_s3_images.arn
}

module "iam_policy_s3_logs" {
  source             = "../../../modules/iam_policy"
  policy_name        = "foo-dev-s3-logs-policy"
  policy_description = "foo dev s3 logs policy"
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
        Resource = "${module.s3_logs.bucket_arn}/*"
      }
    ]
  })
}

module "iam_role_policy_attachment_ecs_s3_logs" {
  source     = "../../../modules/iam_role_policy_attachment"
  role_name  = module.iam_role_ecs_task.name
  policy_arn = module.iam_policy_s3_logs.arn
}

module "iam_policy_ses" {
  source             = "../../../modules/iam_policy"
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

module "iam_role_policy_attachment_ecs_ses" {
  source     = "../../../modules/iam_role_policy_attachment"
  role_name  = module.iam_role_ecs_task.name
  policy_arn = module.iam_policy_ses.arn
}

module "iam_policy_cwlogs" {
  source             = "../../../modules/iam_policy"
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

module "iam_role_policy_attachment_ecs_cwlogs" {
  source     = "../../../modules/iam_role_policy_attachment"
  role_name  = module.iam_role_ecs_task.name
  policy_arn = module.iam_policy_cwlogs.arn
}

module "iam_role_policy_attachment_ecs_exec_cwlogs" {
  source     = "../../../modules/iam_role_policy_attachment"
  role_name  = module.iam_role_ecs_task_exec.name
  policy_arn = module.iam_policy_cwlogs.arn
}

module "iam_policy_parameter" {
  source             = "../../../modules/iam_policy"
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
        Resource = "*"
      }
    ]
  })
}

module "iam_role_policy_attachment_ecs_parameter" {
  source     = "../../../modules/iam_role_policy_attachment"
  role_name  = module.iam_role_ecs_task_exec.name
  policy_arn = module.iam_policy_parameter.arn
}

module "iam_role_policy_attachment_ecs_exce" {
  source     = "../../../modules/iam_role_policy_attachment"
  role_name  = module.iam_role_ecs_task_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

module "iam_role_policy_attachment_ecs_ecr" {
  source     = "../../../modules/iam_role_policy_attachment"
  role_name  = module.iam_role_ecs_task_exec.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
