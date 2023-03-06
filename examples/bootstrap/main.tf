module "bootstrap" {
  source = "../../modules/aws/bootstrap"

  providers = {
    aws.admin     = aws.tooling
    aws.delegated = aws.tooling
  }

  region = var.region

  tags = var.tags

  s3_statebucket_name   = var.s3_statebucket_name
  dynamo_locktable_name = var.dynamo_locktable_name
}

module "bootstrap_network_account_access" {
  source = "../../modules/aws/bootstrap"

  providers = {
    aws.admin     = aws.tooling
    aws.delegated = aws.network
  }

  region = var.region

  tags = var.tags

  delegated_access_only = true

  depends_on = [
    module.bootstrap
  ]
}

module "bootstrap_dev_account_access" {
  source = "../../modules/aws/bootstrap"

  providers = {
    aws.admin     = aws.tooling
    aws.delegated = aws.dev
  }

  region = var.region

  tags = var.tags

  delegated_access_only = true

  depends_on = [
    module.bootstrap
  ]
}

module "bootstrap_test_account_access" {
  source = "../../modules/aws/bootstrap"

  providers = {
    aws.admin     = aws.tooling
    aws.delegated = aws.test
  }

  region = var.region

  tags = var.tags

  delegated_access_only = true

  depends_on = [
    module.bootstrap
  ]
}

module "bootstrap_sec_account_access" {
  source = "../../modules/aws/bootstrap"

  providers = {
    aws.admin     = aws.tooling
    aws.delegated = aws.sec
  }

  region = var.region

  tags = var.tags

  delegated_access_only = true

  depends_on = [
    module.bootstrap
  ]
}
