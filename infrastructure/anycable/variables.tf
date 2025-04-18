
variable "name" {
  type = string
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "region" {
  type        = string
  description = "AWS Region"
}

variable "profile" {
  type        = string
  description = "AWS Profile"
  default     = null
}

# Terraform variables
variable "desired_capacity" {
  type = string
}

variable "physician_domain" {
  type = string
}

# variable "web_acl_arn" {
#   type    = string
#   default = ""
# }

variable "vpc_id" {
  type        = string
  description = "VPC Id"
}

variable "vpc_private_subnets" {
  type        = string
  description = "Private Subnets"
}

variable "vpc_public_subnets" {
  type        = string
  description = "Public Subnets"
}

variable "master_account_id" {
  type = string
}

variable "cpu" {
  type = string
}

variable "cpu_integer" {
  type = number
}

variable "ecs_desired_count" {
  type = number
}

variable "ecs_anycable_name" {
  type = string
}

variable "memory" {
  type = string
}

variable "memory_integer" {
  type = number
}

variable "rails_env" {
  type = string
}

variable "redis_endpoint" {
  type = string
}

variable "redis_port" {
  type = number
}

variable "ava_anycable_image" {
  type = string
}

variable "ava_anycable_version" {
  type = string
}

variable "postgres_endpoint" {
  type = string
}

variable "postgres_reader_endpoint" {
  type = string
}

variable "postgres_database" {
  type = string
}

variable "postgres_reader_database" {
  type = string
}

variable "postgres_port" {
  type = number
}

variable "postgres_reader_port" {
  type = number
}

variable "database_security_group" {
  type = string
}

variable "audit_database_security_group" {
  type = string
}

variable "audit_replica_database" {
  type = string
}

variable "audit_replica_endpoint" {
  type = string
}

variable "audit_replica_port" {
  type = number
}

variable "tags" {
  type    = map(string)
}

variable "redis_security_group_id" {
  type = string
}

###################

variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to access the ALB"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "internal_alb" {
  description = "Whether the ALB should be internal"
  type        = bool
  default     = false
}

variable "enable_deletion_protection" {
  description = "Whether to enable deletion protection on the ALB"
  type        = bool
  default     = false
}

variable "container_port" {
  description = "Port exposed by the container"
  type        = number
  default     = 80
}

variable "health_check_path" {
  description = "Path for ALB health checks"
  type        = string
  default     = "/health_checks"
}

variable "health_check_healthy_threshold" {
  description = "Number of consecutive health check successes required"
  type        = number
  default     = 2
}

variable "health_check_unhealthy_threshold" {
  description = "Number of consecutive health check failures required"
  type        = number
  default     = 3
}

variable "health_check_timeout" {
  description = "Health check timeout in seconds"
  type        = number
  default     = 120
}

variable "health_check_interval" {
  description = "Health check interval in seconds"
  type        = number
  default     = 300
}

variable "health_check_matcher" {
  description = "HTTP response codes to consider as healthy"
  type        = string
  default     = "200-499"
}

variable "desired_count" {
  description = "Desired number of tasks/instances"
  type        = number
  default     = 1
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "log_retention_days" {
  description = "Number of days to retain CloudWatch logs"
  type        = number
  default     = 365
}
