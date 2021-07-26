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

variable "create_rw_user" {
  default = true
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
