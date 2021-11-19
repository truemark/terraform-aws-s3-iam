variable "name" {}

variable "path" {
  default = "/terraform/"
}

variable "acl" {
  default = "private"
}

variable "versioning" {
  default = false
}

variable "force_destroy" {
  default = false
}

variable "block_public_acls" {
  default = true
}

variable "block_public_policy" {
  default = true
}

variable "restrict_public_buckets" {
  default = true
}

variable "ignore_public_acls" {
  default = true
}

variable "create_ro_user" {
  default = true
}

variable "ro_user_name" {
  description = "Name of the read-only user. Default is {var.name}-ro."
  default = null
}

variable "create_rw_user" {
  default = true
}

variable "rw_user_name" {
  description = "Name of the read-write user. Default is {var.name}-rw."
  default = null
}

variable "enable_cloudfront_access" {
  default = false
}

variable "expiration_days" {
    default = -1
}

variable "version_expiration_days" {
  default = -1
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "s3_tags" {
  description = "A map of tags to add to the s3 bucket."
  type        = map(string)
  default = {}
}

variable "rw_user_tags" {
  description = "A map of tags to add to the read-write IAM user."
  type        = map(string)
  default = {}
}

variable "ro_user_tags" {
  description = "A map of tags to add to the read-only IAM user."
  type        = map(string)
  default = {}
}
