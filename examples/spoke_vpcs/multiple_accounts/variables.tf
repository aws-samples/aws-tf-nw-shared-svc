/*---------------------------------------------------------
Provider Variable
---------------------------------------------------------*/
variable "region" {
  description = "The AWS Region e.g. us-east-1 for the environment"
  type        = string
}

/*---------------------------------------------------------
Common Variables
---------------------------------------------------------*/
variable "project" {
  description = "Project to be used on all the resources identification"
  type        = string
}

variable "tags" {
  description = "Mandatory tags for the resources"
  type        = map(string)
}

/*---------------------------------------------------------
Connected VPCs Variables
---------------------------------------------------------*/
