variable "environment" {
  description = "Environment name"
  type        = string
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "use_ipam" {
  description = "Whether to use IPAM for VPC CIDR allocation"
  type        = bool
  default     = true
}

variable "ipam_pool_id" {
  description = "IPAM pool ID for VPC allocation"
  type        = string
  default     = null
}

variable "vpc_cidr" {
  description = "VPC CIDR block (used when not using IPAM)"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_netmask_length" {
  description = "Netmask length for VPC when using IPAM"
  type        = number
  default     = 24
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "subnet_newbits" {
  description = "Number of additional bits for subnet calculation"
  type        = number
  default     = null
}

variable "subnet_types" {
  description = "List of subnet types (public/private) matching availability_zones"
  type        = list(string)
  default     = ["private", "private"]
}

variable "vlan_tags" {
  description = "VLAN tags for subnets"
  type        = list(number)
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_support" {
  description = "Enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "enable_flow_logs" {
  description = "Enable VPC Flow Logs"
  type        = bool
  default     = true
}

variable "create_private_zone" {
  description = "Create Route53 private hosted zone"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
