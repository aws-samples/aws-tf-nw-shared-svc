resource "aws_security_group" "vpce_sg" {
  # checkov:skip=CKV2_AWS_5: SG is attached in the resource module
  # checkov:skip=CKV_AWS_23: N/A
  name        = "${var.project}-common-vpce-sg"
  description = "Common Security Group for VPC Endpoints"
  vpc_id      = data.aws_vpc.vpc.id

  tags = merge(
    {
      Name    = "${var.project}-common-vpce-sg"
      Product = "NW Shared Service VPCE"
    },
    var.tags
  )
}

#tfsec:ignore:aws-vpc-no-public-ingress-sgr
resource "aws_security_group_rule" "ingress_vpce_sg" {
  description       = "Allow inbound traffic on HTTPS"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.vpce_sg.id
}

#tfsec:ignore:aws-vpc-no-public-egress-sgr
resource "aws_security_group_rule" "egress_vpce_sg" {
  description       = "Allow egress to all from VPCE"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.vpce_sg.id
}

data "aws_security_group" "vpce_sg" {
  id = aws_security_group.vpce_sg.id
}
