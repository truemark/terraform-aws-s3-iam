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

variable "ia_transition_days" {
  default = -1
  type = number
  description = "Days before moving content to infrequent access"
}

variable "ia_storage_class" {
  default = "STANDARD_IA"
  description = "One of STANDARD_IA or ONEZONE_IA"
}

variable "glacier_transition_days" {
  default = -1
  type = number
  description = "Days before moving content to infrequent access"
}
