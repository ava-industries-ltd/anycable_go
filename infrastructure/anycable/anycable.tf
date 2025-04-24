module "anycable" {
  source = "../modules/alb-ecs"

  environment                      = var.environment
  name                             = local.name
  vpc_id                           = var.vpc_id
  ecs_subnet_ids                   = local.private_subnet_ids
  alb_subnet_ids                   = local.public_subnet_ids
  ecr_repository_url               = var.ava_anycable_image
  image_version                    = var.anycable_go_version
  ecs_ami_id                       = "ami-0d20e70ed95692ae5" # /aws/service/ecs/optimized-ami/amazon-linux-2023/arm64/recommended/image_id
  instance_type                    = var.instance_type
  desired_count                    = var.desired_count
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

  # Enable ECS autoscaling
  enable_ecs_autoscaling = false

  alb_logging_bucket = "${var.name}-${var.environment}-${var.region}-logs"

  tags = {
    Environment = var.environment
    Service     = local.name
  }
}
