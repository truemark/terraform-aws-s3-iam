data "aws_canonical_user_id" "current" {}

locals {
  grant_ids = var.enable_cloudfront_access ? ["c4c1ede66af53448b93c283ce9448c4ba468c9432aa01d700d3878632f77d2d0", data.aws_canonical_user_id.current.id] : []
  acl = var.enable_cloudfront_access ? null : var.acl
  expiration_days = var.expiration_days > 0 ? [var.expiration_days] : []
  version_expiration_days = var.version_expiration_days > 0 ? [var.version_expiration_days] : []
}

resource "aws_s3_bucket" "s3" {
  bucket = var.name
  acl = local.acl
  force_destroy = var.force_destroy

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }

  dynamic "lifecycle_rule" {
    for_each = local.expiration_days
    content {
      id      = "expiration_policy"
      enabled = true
      expiration {
        days = lifecycle_rule.value
      }
    }
  }

  dynamic "lifecycle_rule" {
    for_each = local.version_expiration_days
    content {
      id      = "version_expiration_policy"
      enabled = true
      noncurrent_version_expiration {
        days = lifecycle_rule.value
      }
    }
  }

  dynamic "grant" {
    for_each = local.grant_ids
    content {
      id          = grant.value
      permissions = ["FULL_CONTROL"]
      type        = "CanonicalUser"
    }
  }

  versioning {
    enabled = var.versioning
  }

  tags = merge(var.tags, var.s3_tags)
}

resource "aws_s3_bucket_public_access_block" "s3" {
  bucket = aws_s3_bucket.s3.id
  block_public_acls = var.block_public_acls
  block_public_policy = var.block_public_policy
  restrict_public_buckets = var.restrict_public_buckets
  ignore_public_acls = var.ignore_public_acls
}

resource "aws_iam_policy" "rw" {
  name = "${var.name}-read-write"
  path = var.path
  description = "Read-write access to S3 bucket ${var.name}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ReadWrite",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:PutObjectAcl",
                "s3:GetObjectAcl",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:DeleteObject",
                "s3:GetBucketLocation"
            ],
            "Resource": [
                "${aws_s3_bucket.s3.arn}",
                "${aws_s3_bucket.s3.arn}/*"
            ]
        },
        {
            "Sid": "List",
            "Effect": "Allow",
            "Action": "s3:ListBucket",
            "Resource": "${aws_s3_bucket.s3.arn}"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "ro" {
  name = "${var.name}-read-only"
  path = var.path
  description = "Read-only access to S3 bucket ${var.name}"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ReadOnly",
            "Effect": "Allow",
            "Action": [
                "s3:GetObjectAcl",
                "s3:GetObject",
                "s3:ListBucket",
                "s3:GetBucketLocation"
            ],
            "Resource": [
                "${aws_s3_bucket.s3.arn}",
                "${aws_s3_bucket.s3.arn}/*"
            ]
        },
        {
            "Sid": "List",
            "Effect": "Allow",
            "Action": "s3:ListBucket",
            "Resource": "${aws_s3_bucket.s3.arn}"
        }
    ]
}
EOF
}

resource "aws_iam_user" "rw" {
  count = var.create_rw_user ? 1 : 0
  name = var.rw_user_name == null ? "${var.name}-rw" : var.rw_user_name
  path = var.path
  tags = merge(var.tags, var.rw_user_tags)
}

resource "aws_iam_user_policy_attachment" "rw" {
  count = var.create_rw_user ? 1 : 0
  policy_arn = aws_iam_policy.rw.arn
  user = aws_iam_user.rw[count.index].name
}

resource "aws_iam_user" "ro" {
  count = var.create_ro_user ? 1 : 0
  name = var.ro_user_name == null ? "${var.name}-ro" : var.ro_user_name
  path = var.path
  tags = merge(var.tags, var.ro_user_tags)
}

resource "aws_iam_user_policy_attachment" "ro" {
  count = var.create_ro_user ? 1 : 0
  policy_arn = aws_iam_policy.ro.arn
  user = aws_iam_user.ro[count.index].name
}
