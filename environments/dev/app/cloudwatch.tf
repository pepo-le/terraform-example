# CloudWatch Logsのロググループを作成
module "cwlogs_group" {
  source            = "../../../modules/cloudwatch_logs"
  log_group_name    = "foo-app-dev-log-group"
  retention_in_days = 14
  stream_name       = "foo-app-dev-log-stream"
}
