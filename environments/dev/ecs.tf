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
  task_role_arn            = module.iam_role_ecs_task.arn
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
          containerPort = 3000
        }
      ]
      environment = [
        {
          name  = "APP_NAME"
          value = "foo-dev"
        }
      ]
      secrets = [
        {
          name      = "DB_USER"
          valueFrom = module.ssm_db_user.parameter_arn
        },
        {
          name      = "DB_PASSWORD"
          valueFrom = module.ssm_db_password.parameter_arn
        }
      ],
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          "awslogs-group"         = module.cwlogs_group.log_group_name
          "awslogs-region"        = "us-east-1"
          "awslogs-stream-prefix" = "ecs"
        }
      }
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
  security_groups     = [module.ecs_sg.sg_id]
  assign_public_ip    = true
  vpc_id              = module.vpc.vpc_id
  target_group_arn    = module.alb.target_group_arn
  container_name      = module.ecs_task_definition.name
  container_port      = 3000
}
