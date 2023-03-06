module "connected_vpcs" {
  source = "../../../modules/aws/spoke_vpcs"

  providers = {
    aws     = aws
    aws.hub = aws
  }

  #region = var.region

  project = var.project

  nw_shared_svc_attributes = data.terraform_remote_state.nw_shared_svc.outputs.nss_attributes

  tags = var.tags

  ec2_test_script = "test_connection_dev.sh"

  spoke_vpc_specs = [
    {
      name_prefix = "dev-app1"
      env_name    = "dev"
      cidr_block  = "10.1.0.0/16"
      az_count    = 2
      tags = {
        app-name = "app1"
        account  = "dev"
      }
      network_segment                  = "DEV"
      enable_centralized_vpc_endpoints = true
      enable_hybrid_dns                = true
      create_test_ec2                  = true
      subnets = [
        {
          type        = "transit_gateway"
          name_prefix = "tgw"
          cidrs       = ["10.1.50.0/28", "10.1.50.16/28"]
          tags = {
            role = "tgw"
          }
        },
        {
          type        = "public"
          name_prefix = "web"
          cidrs       = ["10.1.0.0/24", "10.1.1.0/24"]
          tags = {
            role = "web"
          }
        },
        {
          type        = "private"
          name_prefix = "app"
          cidrs       = ["10.1.10.0/24", "10.1.11.0/24"]
          public      = false
          tags = {
            role = "app"
          }
        },
        {
          type        = "private"
          name_prefix = "db"
          cidrs       = ["10.1.20.0/24", "10.1.21.0/24"]
          public      = false
          tags = {
            role = "db"
          }
        }
      ]
    },
    {
      name_prefix = "dev-app2"
      env_name    = "dev"
      cidr_block  = "10.2.0.0/16"
      az_count    = 2
      tags = {
        app-name = "app2"
        account  = "dev"
      }
      network_segment                  = "DEV"
      enable_centralized_vpc_endpoints = true
      vpce_service_codes               = ["s3"] #empty means all
      enable_hybrid_dns                = true
      create_test_ec2                  = true
      subnets = [
        {
          type        = "transit_gateway"
          name_prefix = "tgw"
          cidrs       = ["10.2.50.0/28", "10.2.50.16/28"]
          tags = {
            role = "tgw"
          }
        },
        {
          type        = "public"
          name_prefix = "web"
          cidrs       = ["10.2.0.0/24", "10.2.1.0/24"]
          public      = true
          tags = {
            role = "web"
          }
        },
        {
          type        = "private"
          name_prefix = "app"
          cidrs       = ["10.2.10.0/24", "10.2.11.0/24"]
          public      = false
          tags = {
            role = "app"
          }
        },
        {
          type        = "private"
          name_prefix = "db"
          cidrs       = ["10.2.20.0/24", "10.2.21.0/24"]
          public      = false
          tags = {
            role = "db"
          }
        }
      ]
    },
    {
      name_prefix = "dev-app3"
      env_name    = "dev"
      cidr_block  = "10.3.0.0/16"
      az_count    = 2
      tags = {
        app-name = "app3"
        account  = "dev"
      }
      enable_centralized_vpc_endpoints = true
      enable_hybrid_dns                = true
      create_test_ec2                  = true
      subnets = [
        {
          type        = "transit_gateway"
          name_prefix = "tgw"
          cidrs       = ["10.3.50.0/28", "10.3.50.16/28"]
          tags = {
            role = "tgw"
          }
        },
        {
          type        = "public"
          name_prefix = "web"
          cidrs       = ["10.3.0.0/24", "10.3.1.0/24"]
          tags = {
            role = "web"
          }
        },
        {
          type        = "private"
          name_prefix = "app"
          cidrs       = ["10.3.10.0/24", "10.3.11.0/24"]
          public      = false
          tags = {
            role = "app"
          }
        },
        {
          type        = "private"
          name_prefix = "db"
          cidrs       = ["10.3.20.0/24", "10.3.21.0/24"]
          public      = false
          tags = {
            role = "db"
          }
        }
      ]
    },
  ]
}
