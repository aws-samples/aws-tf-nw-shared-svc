variable "enable_flow_log" {
  description = <<-EOF
  Enable VPC flow logs as per the specs
  EOF
  type        = bool
  default     = false
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
    encrypted                  = optional(bool, false)
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
    encrypted                  = false
    kms_alias                  = ""
    flow_log_role              = ""
    traffic_type               = "ALL"
    max_aggregation_interval   = 600
    file_format                = "plain-text"
    per_hour_partition         = false
    hive_compatible_partitions = false
  }
}

variable "vpc_id" {
  description = <<-EOF
  Identifies the target VPC for which flow logs are enabled
  EOF
  type        = string
}

variable "subnet_ids" {
  description = <<-EOF
  List of target subnet id(s) for which flow logs are enabled.
  if empty, flow logs are enabled at the VPC level
  if eni_ids are also provided, flow logs are enabled at the eni level
  EOF
  type        = list(string)
  default     = []
}

variable "eni_ids" {
  description = <<-EOF
  List of target ENI id(s) for which flow logs are enabled.
  if empty, flow logs are enabled at the VPC level or subnet level
  EOF
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Common and mandatory tags for the resources."
  type        = map(string)
  default     = {}
}
