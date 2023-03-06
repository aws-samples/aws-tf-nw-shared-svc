output "tgw_id" {
  description = "Transit GW Id for the provisioned TGW"
  value       = aws_ec2_transit_gateway.tgw.id
}
