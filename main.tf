resource "aws_s3_bucket" "s3" {
  bucket = var.name
  acl = var.acl
  force_destroy = var.force_destroy

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }

  versioning {
    enabled = var.versioning
  }
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
  name = "${var.name}-rw"
  path = var.path
}

resource "aws_iam_user_policy_attachment" "rw" {
  count = var.create_rw_user ? 1 : 0
  policy_arn = aws_iam_policy.rw.arn
  user = aws_iam_user.rw.name
}

resource "aws_iam_user" "ro" {
  count = var.create_ro_user ? 1 : 0
  name = "${var.name}-ro"
  path = var.path
}

resource "aws_iam_user_policy_attachment" "ro" {
  count = var.create_ro_user ? 1 : 0
  policy_arn = aws_iam_policy.ro.arn
  user = aws_iam_user.ro.name
}
