
variable "organization_name" {
  description = "Snowflake organization name"
  type        = string
}

variable "account_name" {
  description = "Snowflake account name"
  type        = string
}

variable "snowflake_user" {
  description = "Snowflake service user"
  type        = string
}

variable "snowflake_role" {
  description = "Role used by Terraform"
  type        = string
  default     = "ACCOUNTADMIN"
}
