# ECSクラスタを作成
module "ecs_cluster" {
  source       = "../../../modules/ecs_cluster"
  cluster_name = "foo-app-dev-cluster"
}

# ECSタスク定義を作成
module "ecs_task_definition" {
  source                   = "../../../modules/ecs_task_definition"
  task_definition_family   = "foo-app-dev-task-definition"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  task_role_arn            = data.terraform_remote_state.common.outputs.ecs_task_role_arn
  execution_role_arn       = data.terraform_remote_state.common.outputs.ecs_task_exec_role_arn

  container_definitions = jsonencode([
    {
      name      = "foo-app-dev-ecs-task"
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
          value = "foo-app-dev"
        }
      ]
      secrets = [
        {
          name      = "DB_HOST"
          valueFrom = data.terraform_remote_state.common.outputs.ssm_db_hostname
        },
        {
          name      = "DB_USER"
          valueFrom = data.terraform_remote_state.common.outputs.ssm_db_user
        },
        {
          name      = "DB_PASSWORD"
          valueFrom = data.terraform_remote_state.common.outputs.ssm_db_password
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
  source              = "../../../modules/ecs_service"
  service_name        = "foo-app-dev-ecs-service"
  cluster_id          = module.ecs_cluster.id
  task_definition_arn = module.ecs_task_definition.arn
  desired_count       = 1
  launch_type         = "FARGATE"
  subnets             = data.terraform_remote_state.common.outputs.subnet_ids
  security_groups     = [module.ecs_sg.id]
  assign_public_ip    = true
  vpc_id              = data.terraform_remote_state.common.outputs.vpc_id
  target_group_arn    = module.alb.target_group_arn
  container_name      = module.ecs_task_definition.name
  container_port      = 3000
}
