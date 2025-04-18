resource "aws_security_group_rule" "database_security_groups_access" {
  description              = "ALB Database access"
  security_group_id        = var.database_security_group
  type                     = "ingress"
  from_port                = var.postgres_port
  to_port                  = var.postgres_port
  protocol                 = "tcp"
  source_security_group_id = module.anycable.ecs_security_group_id
}

resource "aws_security_group_rule" "audit_database_security_groups_access" {
  description              = "ALB Audit Database access"
  security_group_id        = var.audit_database_security_group
  type                     = "ingress"
  from_port                = var.postgres_port
  to_port                  = var.postgres_port
  protocol                 = "tcp"
  source_security_group_id = module.anycable.ecs_security_group_id
}

resource "aws_security_group_rule" "redis_security_groups_access" {
  description              = "Redis access"
  security_group_id        = var.redis_security_group_id
  type                     = "ingress"
  from_port                = var.redis_port
  to_port                  = var.redis_port
  protocol                 = "tcp"
  source_security_group_id = module.anycable.ecs_security_group_id
}
