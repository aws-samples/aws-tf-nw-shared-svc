variable "vpcs" {
  description = "List of VPCs where test ec2 instances will be created"
  type = list(object({
    vpc_name        = string
    vpc_id          = string
    vpc_role        = string
    subnet_ids      = list(string)
    create_test_ec2 = optional(bool, false)
    tags            = optional(map(string))
  }))
  default = [
  ]
}

# if empty VPCE tests are not created
variable "vpce_cidrs" {
  description = "List of common CIDR blocks where VPC endpoints are hosted in each VPC"
  type        = list(string)
  default     = []
}

# if empty VPCE tests are not created
variable "vpce_services" {
  description = "List of AWS Service codes e.g. s3, dynamodb, for which VPC endpoints need to be tested"
  type        = list(string)
  default     = []
}

variable "instance_type" {
  description = "Instance type e.g. t2.micro, t3.micro"
  type        = string
  default     = "t3.micro"
}

variable "instance_architecture" {
  description = "Instance architecture e.g. x86_64, arm64"
  type        = list(string)
  default     = ["x86_64", "arm64"]
}

variable "instance_volume_type" {
  description = "Volume type e.g. gp2, gp3"
  type        = list(string)
  default     = ["gp2", "gp3", "io1", "iop2"]
}
