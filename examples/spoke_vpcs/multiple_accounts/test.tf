module "connected_vpcs_test" {
  source = "../../../modules/aws/spoke_vpcs"

  providers = {
    aws     = aws.test
    aws.hub = aws.network
  }

  #region = var.region

  project = var.project

  nw_shared_svc_attributes = data.terraform_remote_state.nw_shared_svc.outputs.nss_attributes

  tags = var.tags

  ec2_test_script = "test_connection_test.sh"

  spoke_vpc_specs = [
    {
      name_prefix = "test-app1"
      env_name    = "dev"
      cidr_block  = "10.11.0.0/16"
      az_count    = 2
      tags = {
        app-name = "app1"
        account  = "test"
      }
      network_segment                  = "DEV"
      enable_centralized_vpc_endpoints = true
      enable_hybrid_dns                = true
      create_test_ec2                  = true
      subnets = [
        {
          type        = "transit_gateway"
          name_prefix = "tgw"
          cidrs       = ["10.11.50.0/28", "10.11.50.16/28"]
          tags = {
            role = "tgw"
          }
        },
        {
          type        = "public"
          name_prefix = "web"
          cidrs       = ["10.11.0.0/24", "10.11.1.0/24"]
          tags = {
            role = "web"
          }
        },
        {
          type        = "private"
          name_prefix = "app"
          cidrs       = ["10.11.10.0/24", "10.11.11.0/24"]
          public      = false
          tags = {
            role = "app"
          }
        },
        {
          type        = "private"
          name_prefix = "db"
          cidrs       = ["10.11.20.0/24", "10.11.21.0/24"]
          public      = false
          tags = {
            role = "db"
          }
        }
      ]
    },
    {
      name_prefix = "test-app2"
      env_name    = "dev"
      cidr_block  = "10.12.0.0/16"
      az_count    = 2
      tags = {
        app-name = "app2"
        account  = "test"
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
          cidrs       = ["10.12.50.0/28", "10.12.50.16/28"]
          tags = {
            role = "tgw"
          }
        },
        {
          type        = "public"
          name_prefix = "web"
          cidrs       = ["10.12.0.0/24", "10.12.1.0/24"]
          public      = true
          tags = {
            role = "web"
          }
        },
        {
          type        = "private"
          name_prefix = "app"
          cidrs       = ["10.12.10.0/24", "10.12.11.0/24"]
          public      = false
          tags = {
            role = "app"
          }
        },
        {
          type        = "private"
          name_prefix = "db"
          cidrs       = ["10.12.20.0/24", "10.12.21.0/24"]
          public      = false
          tags = {
            role = "db"
          }
        }
      ]
    },
    {
      name_prefix = "test-app3"
      env_name    = "dev"
      cidr_block  = "10.13.0.0/16"
      az_count    = 2
      tags = {
        app-name = "app3"
        account  = "test"
      }
      #network_segment                  = "ISOLATED"
      enable_centralized_vpc_endpoints = true
      enable_hybrid_dns                = true
      create_test_ec2                  = true
      subnets = [
        {
          type        = "transit_gateway"
          name_prefix = "tgw"
          cidrs       = ["10.13.50.0/28", "10.13.50.16/28"]
          tags = {
            role = "tgw"
          }
        },
        {
          type        = "public"
          name_prefix = "web"
          cidrs       = ["10.13.0.0/24", "10.13.1.0/24"]
          tags = {
            role = "web"
          }
        },
        {
          type        = "private"
          name_prefix = "app"
          cidrs       = ["10.13.10.0/24", "10.13.11.0/24"]
          public      = false
          tags = {
            role = "app"
          }
        },
        {
          type        = "private"
          name_prefix = "db"
          cidrs       = ["10.13.20.0/24", "10.13.21.0/24"]
          public      = false
          tags = {
            role = "db"
          }
        }
      ]
    },
  ]
}
