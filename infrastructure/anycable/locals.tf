data "aws_caller_identity" "current" {
}

data "aws_region" "current" {
}

data "aws_acm_certificate" "physician" {
  domain = var.physician_domain

  statuses = [
    "ISSUED",
  ]
  most_recent = true
}

locals {
  account_id = data.aws_caller_identity.current.account_id
  name ="${var.name}-anycable"
  private_subnet_ids = split(",", var.vpc_private_subnets)
  public_subnet_ids  = split(",", var.vpc_public_subnets)
  container_command = null
  container_environment_variables = [
    { "name" : "ENVIRONMENT", "value" : "${var.rails_env}" },
    { "name" : "AWS_REGION", "value" : "ca-central-1" },
    { "name" : "POSTGRES_ENDPOINT", "value" : "${var.postgres_endpoint}" },
    { "name" : "POSTGRES_REPLICA_ENDPOINT", "value" : "${var.postgres_reader_endpoint}" },
    { "name" : "POSTGRES_DATABASE", "value" : "${var.postgres_database}" },
    { "name" : "POSTGRES_REPLICA_DATABASE", "value" : "${var.postgres_reader_database}" },
    { "name" : "POSTGRES_PORT", "value" : "${var.postgres_port}" },
    { "name" : "POSTGRES_REPLICA_PORT", "value" : "${var.postgres_reader_port}" },
    { "name" : "AUDIT_POSTGRES_REPLICA_DATABASE", "value" : "${var.audit_replica_database}" },
    { "name" : "AUDIT_POSTGRES_REPLICA_ENDPOINT", "value" : "${var.audit_replica_endpoint}" },
    { "name" : "AUDIT_POSTGRES_REPLICA_PORT", "value" : "${var.audit_replica_port}" },
    { "name" : "REDIS_PORT", "value" : "${var.redis_port}" },
    { "name" : "REDIS_ENDPOINT", "value" : "${var.redis_endpoint}" }
  ]
  container_secrets = [
    {
      "name" : "POSTGRES_PASSWORD",
      "valueFrom" : "arn:aws:ssm:${var.region}:${local.account_id}:parameter/database/postgres/password"
    },
    {
      "name" : "POSTGRES_USERNAME",
      "valueFrom" : "arn:aws:ssm:${var.region}:${local.account_id}:parameter/database/postgres/username"
    },
    {
      "name" : "POSTGRES_REPLICA_PASSWORD",
      "valueFrom" : "arn:aws:ssm:${var.region}:${local.account_id}:parameter/database/postgres/replica_password"
    },
    {
      "name" : "POSTGRES_REPLICA_USERNAME",
      "valueFrom" : "arn:aws:ssm:${var.region}:${local.account_id}:parameter/database/postgres/replica_username"
    },
    {
      "name" : "AUDIT_POSTGRES_REPLICA_PASSWORD",
      "valueFrom" : "arn:aws:ssm:${var.region}:${local.account_id}:parameter/database/audit_postgres/replica_password"
    },
    {
      "name" : "AUDIT_POSTGRES_REPLICA_USERNAME",
      "valueFrom" : "arn:aws:ssm:${var.region}:${local.account_id}:parameter/database/audit_postgres/replica_username"
    }
  ]
}
