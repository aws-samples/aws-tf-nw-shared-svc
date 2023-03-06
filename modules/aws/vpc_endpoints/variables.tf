/*---------------------------------------------------------
Provider Variable
---------------------------------------------------------*/
variable "region" {
  description = "The AWS Region e.g. us-east-1 for the environment."
  type        = string
}

/*---------------------------------------------------------
Common Variables
---------------------------------------------------------*/
variable "project" {
  description = "Project name, used as prefix/suffix for resource identification."
  type        = string
}

variable "env_name" {
  description = "Environment name e.g. dev, prod, used for resource identification."
  type        = string
}

variable "tags" {
  description = "Common and mandatory tags for the resources."
  type        = map(string)
}

/*---------------------------------------------------------
VPC/Subnet(s) for VPC Endpoint(s)
---------------------------------------------------------*/
variable "vpc_tags" {
  description = <<-EOF
  Tags to discover target VPC, these tags should uniquely identify a VPC to host the VPC Endpoint(s).
  Other option is to provide the mutually exclusive `vpc_id`.
  Either `vpc_tags` or `vpc_id` must be provided.
  If both are provided `vpc_id` is used.
  EOF
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = <<-EOF
  Identifies the target VPC to host the VPC Endpoint(s).
  Other option is to provide the mutually exclusive `vpc_tags` to discover the VPC.
  Either `vpc_tags` or `vpc_id` must be provided.
  If both are provided `vpc_id` is used.
  EOF
  type        = string
  default     = null
}


variable "subnet_tags" {
  description = <<-EOF
  Tags to discover target subnets in the VPC, these tags should identify one or more subnets to host the VPC Endpoint(s).
  Other option is to provide the mutually exclusive `az_to_subnets` for the target subnets.
  Either `subnet_tags` or `az_to_subnets` must be provided.
  If both are provided `az_to_subnets` is used.
  EOF
  type        = map(string)
  default     = {}
}

# variable "subnet_ids" {
#   description = <<-EOF
#   List of target subnet id(s) to host the VPC Endpoint(s).
#   Other options is to provide the mutually exclusive `subnet_tags` to discover target subnet(s) in the VPC.
#   Either `subnet_tags` or `subnet_ids` must be provided.
#   If both are provided `subnet_ids` is used.
#   EOF
#   type        = list(string)
#   default     = []
# }

variable "az_to_subnets" {
  description = <<-EOF
  Map of Availability Zone to target subnet(s) to host the VPC Endpoint(s).
  Other options is to provide the mutually exclusive `subnet_tags` to discover target subnet(s) in the VPC.
  Either `subnet_tags` or `az_to_subnets` must be provided.
  If both are provided `az_to_subnets` is used.
  EOF
  type = map(object({
    id         = string
    cidr_block = string
    az_id      = string
  }))
  default = {}
}

/*---------------------------------------------------------
Encryption
---------------------------------------------------------*/
variable "kms_admin_roles" {
  description = <<-EOF
  List Administrator roles for KMS.
  Provide at least one Admin role if kms needs to be created for the encryption of VPC flow logs e.g. ["Admin"].
  It can be empty if `enable_flow_log` is false.
  It can be empty if `enable_flow_log` is true but `flow_log_specs.encrypted` is false.
  EOF
  type        = list(string)
  default     = []
}

/*---------------------------------------------------------
VPC Endpoint(s) to create
---------------------------------------------------------*/
variable "vpce_service_codes" {
  description = <<-EOF
  List of the service codes for the supported AWS Services for which VPC endpoints will be created.
  EOF
  type        = list(string)
  default     = []
}

variable "enable_flow_log" {
  description = <<-EOF
  Enable VPC flow log for all the VPC endpoints, unless overridden by `flow_log_service_codes`.
  if true and `flow_log_service_codes` is null or empty, flow logs will be enabled at the VPCE subnet level.
  if false VPC flow logs will be disabled.
  EOF
  type        = bool
  default     = false
}

variable "flow_log_service_codes" {
  description = <<-EOF
  List of the service codes for the supported AWS Services for which flow log will be enabled.
  if `enable_flow_log` is true and `flow_log_service_codes` is null or empty, flow logs will be enabled at the VPCE subnet level.
  if `enable_flow_log` is true and `flow_log_service_codes` is not empty, flow logs will be enabled at the ENI level for the listed services.
  if `enable_flow_log` is false VPC flow logs will be disabled, regardless of `flow_log_service_codes`
  EOF
  type        = list(string)
  default     = []
}

variable "flow_log_specs" {
  description = <<-EOF
  Options to customize the VPC flow logs, effective if `enable_flow_log` is true.
  - `destination_type`, optional. Valid values: cloud-watch-logs or s3. default: cloud-watch-logs
  - `destination_name`, optional. Provide an existing `destination_name`.
    For `destination_type` s3, provide an existing s3 bucket name
    For `destination_type` cloud-watch-logs, provide an existing cloudwatch log group
    If not provided, a destination will be created based on the `destination_type`
  - `encrypted`, optional. Should the flow logs be encrypted. default: `true`
    Not applicable, if `destination_name` is provided.
  - `kms_alias`, optional. Provide an existing `kms_alias` to encrypt the flow logs.
    If not provided, an appropriate KMS is created based on the `destination_type`
    Not applicable, if `encrypted` is false or `destination_name` is provided.
  - `flow_log_role`, optional. Provide an existing IAM role for the flow log with permissions to log to `destination_type`
    If not provided, an appropriate IAM role is created with permissions to log to `destination_type`
  `traffic_type`, optional. Type for traffic to capture in the flow log. ACCEPT, REJECT, or ALL. Default is ALL
  `max_aggregation_interval`, optional. Max aggregation interval for the flow log capture before sending to destination. 600 or 60. Default is 600
  `file_format`, optional. if `destination_type` is s3, provide one of the supported file formats. plain-text or parquet. Default is plain-text
  `per_hour_partition`, optional. if `destination_type` is s3, should one hour partition be created. Default is false
  `hive_compatible_partitions`, optional. if `destination_type` is s3, should hive compatible partition be created. Default is false
  EOF
  type = object({
    destination_type           = optional(string, "cloud-watch-logs")
    destination_name           = optional(string, "")
    encrypted                  = optional(bool, true)
    kms_alias                  = optional(string, "")
    flow_log_role              = optional(string, "")
    traffic_type               = optional(string, "ALL")
    max_aggregation_interval   = optional(number, 600)
    file_format                = optional(string, "plain-text")
    per_hour_partition         = optional(bool, false)
    hive_compatible_partitions = optional(bool, false)
  })
  validation {
    condition     = try(length(var.flow_log_specs.destination_type), 0) == 0 ? true : contains(["cloud-watch-logs", "s3"], var.flow_log_specs.destination_type)
    error_message = "Error: destination_type Valid values: cloud-watch-logs or s3."
  }
  validation {
    condition     = try(length(var.flow_log_specs.traffic_type), 0) == 0 ? true : contains(["ACCEPT", "REJECT", "ALL"], var.flow_log_specs.traffic_type)
    error_message = "Error: traffic_type Valid values: ACCEPT,REJECT, or ALL."
  }
  validation {
    condition     = try(length(var.flow_log_specs.file_format), 0) == 0 ? true : contains(["plain-text", "parquet"], var.flow_log_specs.file_format)
    error_message = "Error: file_format Valid values: plain-text or parquet."
  }
  validation {
    condition     = try(abs(var.flow_log_specs.max_aggregation_interval), 0) == 0 ? true : contains([600, 60], var.flow_log_specs.max_aggregation_interval)
    error_message = "Error: max_aggregation_interval Valid values: 60 or 600."
  }
  default = {
    destination_type           = "cloud-watch-logs"
    destination_name           = ""
    encrypted                  = true
    kms_alias                  = ""
    flow_log_role              = ""
    traffic_type               = "ALL"
    max_aggregation_interval   = 600
    file_format                = "plain-text"
    per_hour_partition         = false
    hive_compatible_partitions = false
  }
}

variable "generate_vpce_test_script" {
  description = <<-EOF
  Generate a test script that can be used to test all the provisioned VPC endpoints.
  EOF
  type        = bool
  default     = false
}
