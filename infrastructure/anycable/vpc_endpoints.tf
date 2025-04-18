

# https://docs.aws.amazon.com/AmazonECR/latest/userguide/vpc-endpoints.html
resource "aws_vpc_endpoint" "ecs" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.ecs"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    module.emr.ecs_security_group_id
  ]
  subnet_ids = local.private_subnet_ids

  private_dns_enabled = false

  tags = merge(
    var.tags,
    {
      Name = "ECS"
    }
  )
}

resource "aws_vpc_endpoint" "ecr-api" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    module.emr.ecs_security_group_id
  ]
  subnet_ids = local.private_subnet_ids

  private_dns_enabled = false

  tags = merge(
    var.tags,
    {
      Name = "ECR API"
    }
  )
}

resource "aws_vpc_endpoint" "ecr-dkr" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    module.emr.ecs_security_group_id
  ]

  subnet_ids = local.private_subnet_ids

  private_dns_enabled = false

  tags = merge(
    var.tags,
    {
      Name = "ECR Docker Repository"
    }
  )
}

//resource "aws_vpc_endpoint" "logs" {
//  vpc_id            = module.vpc.id
//  service_name      = "com.amazonaws.${var.region"]}.logs"
//  vpc_endpoint_type = "Interface"
//
//  security_group_ids = [
//    module.ecs_alb.security_group_id
//  ]
//
//  private_dns_enabled = true
//
//  tags = merge(
//  var.tags"],
//  {
//    Name = "CloudWatch"
//  }
//  )
//}
