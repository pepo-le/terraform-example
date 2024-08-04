# ECSクラスタを作成
module "ecs_cluster" {
  source       = "../../../modules/ecs_cluster"
  cluster_name = "foo-subapp-dev-cluster"
}

# ECSタスク定義を作成
module "ecs_task_definition" {
  source                   = "../../../modules/ecs_task_definition"
  task_definition_family   = "foo-subapp-dev-task-definition"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  task_role_arn            = data.terraform_remote_state.common.outputs.iam_role_ecs_task_role_arn
  execution_role_arn       = data.terraform_remote_state.common.outputs.iam_role_ecs_task_exec_role_arn

  container_definitions = jsonencode([
    {
      name      = "foo-subapp-dev-ecs-container"
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
          value = "foo-subapp-dev"
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
  service_name        = "foo-subapp-dev-ecs-service"
  cluster_id          = module.ecs_cluster.id
  task_definition_arn = module.ecs_task_definition.arn
  desired_count       = 1
  launch_type         = "FARGATE"
  subnets             = data.terraform_remote_state.common.outputs.public_subnet_ids
  security_groups     = [module.ecs_sg.id]
  assign_public_ip    = true
  vpc_id              = data.terraform_remote_state.common.outputs.vpc_id
  target_group_arn    = module.alb_target_group.tg_arn
  container_name      = module.ecs_task_definition.container_name
  container_port      = 3000
  depends_on          = [module.alb_target_group]
}

module "ecs_autoscaling" {
  source                 = "../../../modules/ecs_autoscaling"
  cluster_name           = module.ecs_cluster.name
  service_name           = module.ecs_service.service_name
  target_cpu_utilization = 50
  max_capacity           = 3
  min_capacity           = 1
  scaling_policy_name    = "foo-subapp-dev-scaling-policy"
  scale_in_cooldown      = 300
  scale_out_cooldown     = 300
  depends_on             = [module.ecs_service]
}
