data "aws_organizations_organization" "org" {}

data "aws_vpc" "vpc" {
  id   = try(length(var.vpc_id), 0) != 0 ? var.vpc_id : null
  tags = try(length(var.vpc_id), 0) != 0 ? null : var.vpc_tags
}

data "aws_subnets" "subnets" {
  count = try(length(var.subnet_tags), 0) != 0 ? 1 : 0
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }
  tags = var.subnet_tags
}

data "aws_subnet" "subnet" {
  for_each = try(length(var.subnet_tags), 0) != 0 ? toset(data.aws_subnets.subnets[0].ids) : toset([])
  id       = each.value
}
