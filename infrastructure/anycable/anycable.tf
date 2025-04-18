module "emr" {
  source = "../../modules/alb-ecs"

  environment                      = var.environment
  name                             = local.name
  vpc_id                           = var.vpc_id
  ecs_subnet_ids                   = local.private_subnet_ids
  alb_subnet_ids                   = local.public_subnet_ids
  ecr_repository_url               = var.ava_emr_image
  image_version                    = var.ava_emr_version
  ecs_ami_id                       = "ami-0aa7113d93a24e578" # /aws/service/ecs/optimized-ami/amazon-linux-2023/recommended
  instance_type                    = var.instance_type
  desired_count                    = var.ecs_desired_count
  acm_certificate_arn              = data.aws_acm_certificate.physician.arn
  container_cpu                    = var.cpu
  container_memory                 = var.memory
  container_environment            = local.container_environment_variables
  container_secrets                = local.container_secrets
  container_command                = local.container_command
  health_check_healthy_threshold   = var.health_check_healthy_threshold
  health_check_unhealthy_threshold = var.health_check_unhealthy_threshold
  health_check_timeout             = var.health_check_timeout
  health_check_interval            = var.health_check_interval
  health_check_path                = var.health_check_path
  health_check_matcher             = var.health_check_matcher
  web_acl_arn                      = var.web_acl_arn

  # Enable ECS autoscaling
  enable_ecs_autoscaling       = var.emr_enable_ecs_autoscaling
  ecs_autoscaling_min_capacity = var.emr_ecs_autoscaling_min_capacity
  ecs_autoscaling_max_capacity = var.emr_ecs_autoscaling_max_capacity
  scale_out_alarm_config       = var.emr_scale_out_alarm_config == null ? null : jsondecode((var.emr_scale_out_alarm_config))
  scale_in_alarm_config        = var.emr_scale_in_alarm_config == null ? null : jsondecode((var.emr_scale_in_alarm_config))

  alb_logging_bucket = "${var.name}-${var.environment}-${var.region}-logs"

  tags = {
    Environment = var.environment
    Service     = local.name
  }
}
