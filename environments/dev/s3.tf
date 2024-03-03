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
