module "remote_state" {
  source        = "nozaq/remote-state-s3-backend/aws"
  kms_key_alias = "tf-state-key"

  providers = {
    aws         = aws
    aws.replica = aws.replica
  }
}
