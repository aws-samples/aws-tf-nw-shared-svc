variable "enable_resolver_query_log" {
  description = <<-EOF
  Enable Route53 resolver query logging
  EOF
  type        = bool
  default     = false
}

variable "resolver_query_log_specs" {
  description = <<-EOF
  Options to customize the resolver query logging, effective if `enable_resolver_query_log` is true.
  - `destination_type`, optional. Valid values: cloud-watch-logs or s3. default: cloud-watch-logs
  - `destination_name`, optional. Provide an existing `destination_name`.
    For `destination_type` s3, provide an existing s3 bucket name
    For `destination_type` cloud-watch-logs, provide an existing cloudwatch log group
    If not provided, a destination will be created based on the `destination_type`
  - `encrypted`, optional. Should the resolver query logs be encrypted. default: `false`
    Not applicable, if `destination_name` is provided.
  - `kms_alias`, optional. Provide an existing `kms_alias` to encrypt the resolver query logs.
    Not applicable, if `encrypted` is false or `destination_name` is provided.
  EOF
  type = object({
    destination_type = optional(string, "cloud-watch-logs")
    destination_name = optional(string, "")
    encrypted        = optional(bool, false)
    kms_alias        = optional(string, "")
  })
  validation {
    condition     = try(length(var.resolver_query_log_specs.destination_type), 0) == 0 ? true : contains(["cloud-watch-logs", "s3"], var.resolver_query_log_specs.destination_type)
    error_message = "Error: destination_type Valid values: cloud-watch-logs or s3."
  }
  default = {
    destination_type = "cloud-watch-logs"
    destination_name = ""
    encrypted        = false
    kms_alias        = ""
  }
}

variable "vpc_ids" {
  description = <<-EOF
  Identifies the target VPCs for which resolver query logs are enabled
  EOF
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Common and mandatory tags for the resources."
  type        = map(string)
  default     = {}
}
