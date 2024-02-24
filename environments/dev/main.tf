# パラメータストアのパラメータを作成
module "ssm_db_user" {
  source                = "../../modules/ssm"
  parameter_name        = "foo-dev-db-user"
  parameter_type        = "String"
  parameter_description = "foo dev db user"
  # 後で変更するために、初期値を設定
  parameter_value = "uninitializeuser"
}

module "ssm_db_password" {
  source                = "../../modules/ssm"
  parameter_name        = "foo-dev-db-password"
  parameter_type        = "SecureString"
  parameter_description = "foo dev db password"
  # 後で変更するために、初期値を設定
  parameter_value = "uninitializepassword"
}

# CloudWatch Logsのロググループを作成
module "cwlogs_group" {
  source            = "../../modules/cloudwatch_logs"
  log_group_name    = "foo-dev-log-group"
  retention_in_days = 14
  stream_name       = "foo-dev-log-stream"
}

# S3バケットを作成
module "s3_web" {
  source      = "../../modules/s3"
  bucket_name = "foo-dev-bucket-public-web-13579"
  is_public   = true
}

module "s3_log" {
  source      = "../../modules/s3"
  bucket_name = "foo-dev-bucket-public-log-13579"
  is_public   = false
}

# IAMロールの作成
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
  role_name  = module.iam_role_ecs_task_execution.name
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
  role_name  = module.iam_role_ecs_task_execution.name
  policy_arn = module.iam_policy_ses.arn
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

module "iam_role_policy_attachment_parameter" {
  source     = "../../modules/iam_role_policy_attachment"
  role_name  = module.iam_role_ecs_task_execution.name
  policy_arn = module.iam_policy_parameter.arn
}

module "iam_role_policy_attachment-ecr" {
  source     = "../../modules/iam_role_policy_attachment"
  role_name  = module.iam_role_ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# VPCを作成
module "vpc" {
  source             = "../../modules/vpc"
  cidr_block         = "10.10.0.0/16"
  vpc_name           = "foo-dev-vpc"
  subnet_cidr_blocks = ["10.10.0.0/24", "10.10.1.0/24"]
  availability_zones = ["us-east-1a", "us-east-1b"]
}

# セキュリティグループを作成
module "http_sg" {
  source  = "../../modules/security_group"
  sg_name = "foo-dev-http-sg"
  vpc_id  = module.vpc.vpc_id

  rule_map = {
    http = {
      type                     = "ingress"
      from_port                = 80
      to_port                  = 80
      protocol                 = "TCP"
      cidr_blocks              = ["0.0.0.0/0"]
      ipv6_cidr_blocks         = null
      source_security_group_id = null
      description              = "allow http"
    }
  }
}

module "rds_sg" {
  source  = "../../modules/security_group"
  sg_name = "foo-dev-rds-sg"
  vpc_id  = module.vpc.vpc_id

  rule_map = {
    http = {
      type                     = "ingress"
      from_port                = 3306
      to_port                  = 3306
      protocol                 = "TCP"
      cidr_blocks              = null
      ipv6_cidr_blocks         = null
      source_security_group_id = module.http_sg.sg_id
      description              = "allow http"
    }
  }
}

# ECRリポジトリを作成
module "ecr" {
  source          = "../../modules/ecr"
  repository_name = "foo-dev-repository"
}

# ECSクラスタを作成
module "ecs_cluster" {
  source       = "../../modules/ecs_cluster"
  cluster_name = "foo-dev-cluster"
}

# ECSタスク定義を作成
module "ecs_task_definition" {
  source                   = "../../modules/ecs_task_definition"
  task_definition_family   = "foo-dev-task-definition"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = module.iam_role_ecs_task_execution.arn

  container_definitions = jsonencode([
    {
      name      = "foo-dev-ecs-task"
      image     = "${module.ecr.repository_url}:latest"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        },
      ],
      environment = [
        {
          name  = "DB_USER"
          value = module.ssm_db_user.parameter_arn
        }
      ]
      secrets = [
        {
          name      = "DB_PASSWORD"
          valueFrom = module.ssm_db_password.parameter_arn
        }
      ]
    },
  ])
}

# ECSサービスを作成
module "ecs_service" {
  source              = "../../modules/ecs_service"
  service_name        = "foo-dev-ecs-service"
  cluster_id          = module.ecs_cluster.id
  task_definition_arn = module.ecs_task_definition.arn
  desired_count       = 1
  launch_type         = "FARGATE"
  subnets             = module.vpc.subnet_ids
  security_groups     = [module.http_sg.sg_id]
  assign_public_ip    = true
  vpc_id              = module.vpc.vpc_id
}

# ALBを作成
module "alb" {
  source                     = "../../modules/alb"
  alb_name                   = "foo-dev-alb"
  internal                   = false
  alb_sg_id                  = module.http_sg.sg_id
  alb_subnet_ids             = module.vpc.subnet_ids
  enable_deletion_protection = false
  alb_tg_name                = "foo-dev-alb-tg"
  alb_port                   = 80
  alb_tg_vpc_id              = module.vpc.vpc_id
}

# RDSインスタンスを作成
module "rds" {
  source             = "../../modules/rds"
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.subnet_ids
  security_group_ids = [module.rds_sg.sg_id]

  multi_az            = false
  publicly_accessible = false
  skip_final_snapshot = true
  tags = {
    Name = "foo-dev-rds"
  }
  allocated_storage = 20
  storage_type      = "gp2"
  engine            = "mysql"
  engine_version    = "8.0.35"
  instance_class    = "db.t3.micro"
  db_name           = "foo_db"
  # 後で変更するために、初期値を設定
  db_username = "uninitializeuser"
  # 後で変更するために、初期値を設定
  db_password          = "uninitializepassword"
  parameter_group_name = "default.mysql8.0"
}
