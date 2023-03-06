#terraform apply -target module.nw_shared_svc.module.shared_tgw
#terraform apply -target module.nw_shared_svc.module.shared_services_vpc
#terraform apply
module "nw_shared_svc" {
  source = "../../../modules/aws/nw_shared_svc"

  region = var.region

  project  = var.project
  env_name = var.env_name

  tags = var.tags

  #VPC
  #super_net_cidr_blocks = ["10.0.0.0/8", "172.0.0.0/8"] #optional, default []
  cidr_block = "10.51.0.0/16"
  az_count   = 2

  #disable sharing
  share_with_org = false

  #optional, default ["ALL", "ISOLATED"] network segments are always available
  supported_network_segments = ["DEV", "TEST"]

  vpce_service_codes = [
    "ec2",
    "ec2messages",
    "ssm",
    "ssmmessages",
    "s3",
    # "iot.data",
    # "notebook",
    # "studio",
    # "execute-api",
  ]

  generate_vpce_test_script = true

  #optional, default []
  #if provided, creates dns inbound resolver endpoints
  on_premises_cidrs = ["172.32.0.0/16", "172.33.0.0/16"]

  #optional default []
  #if provided, creates dns outbound resolver endpoints
  outbound_dns_resolver_config = [
    {
      domain_name         = "site1.mycompany.com"
      target_ip_addresses = ["172.32.0.2", "172.32.1.2"]
    },
    {
      domain_name         = "site2.mycompany.com"
      target_ip_addresses = ["172.33.0.2", "172.33.1.2"]
    }
  ]
}
