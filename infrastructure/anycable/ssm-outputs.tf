resource "aws_ssm_parameter" "emr_task_role_arn" {
  name        = "/ava/${var.environment}/config/emr/emr_task_role_arn"
  description = "EMR task role ARN for ${var.name}-${var.environment}"
  type        = "String"
  value       = module.emr.task_role_arn
}

resource "aws_ssm_parameter" "emr_task_role_name" {
  name        = "/ava/${var.environment}/config/emr/emr_task_role_name"
  description = "EMR task role name for ${var.name}-${var.environment}"
  type        = "String"
  value       = module.emr.task_role_name
}


# # Outputs
# output "alb_dns_name" {
#   description = "The DNS name of the ALB"
#   value       = module.ecs_service.alb_dns_name
# }

# output "ecs_service_name" {
#   description = "The ECS service name"
#   value       = module.ecs_service.ecs_service_name
# }

# output "ecs_cluster_name" {
#   description = "The ECS cluster name"
#   value       = module.ecs_service.ecs_cluster_name
# }
