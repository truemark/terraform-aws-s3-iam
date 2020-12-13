# AWS S3 IAM Terraform Module

This terraform module will create an S3 bucket along with policies for
read-write access, read-only access and attached IAM users for those
policies.

Example Usage:
```hcl
data "aws_caller_identity" "current" {}
locals {
  s3_bucket = "${data.aws_caller_identity.current.account_id}-${local.name}"
}
module "s3" {
  source = "truemark/s3-iam/aws"
  name = local.s3_bucket
}
``` 
