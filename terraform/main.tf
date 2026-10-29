
terraform {
  required_providers {
    snowflake = {
      source  = "Snowflake-Labs/snowflake"
      version = ">= 1.0.0"
    }
  }
}

provider "snowflake" {
  organization_name = var.organization_name
  account_name      = var.account_name
  user              = var.snowflake_user
  role              = var.snowflake_role
  authenticator     = "SNOWFLAKE_JWT"
}

resource "snowflake_database" "mortgage" {
  name = "MORTGAGE_DB"
}

resource "snowflake_schema" "raw" {
  database = snowflake_database.mortgage.name
  name     = "RAW"
}

resource "snowflake_schema" "silver" {
  database = snowflake_database.mortgage.name
  name     = "SILVER"
}

resource "snowflake_schema" "gold" {
  database = snowflake_database.mortgage.name
  name     = "GOLD"
}

resource "snowflake_warehouse" "mortgage" {
  name           = "MORTGAGE_WH"
  warehouse_size = "XSMALL"
  auto_suspend   = 60
  auto_resume    = true
}
