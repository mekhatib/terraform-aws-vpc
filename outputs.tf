# modules/networking/vpc/outputs.tf

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}

# Subnet outputs
output "subnet_ids" {
  description = "List of all subnet IDs"
  value       = aws_subnet.private[*].id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value = [
    for idx, subnet in aws_subnet.private : subnet.id
    if var.subnet_types[idx] == "private"
  ]
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value = [
    for idx, subnet in aws_subnet.private : subnet.id
    if var.subnet_types[idx] == "public"
  ]
}

# For specific subnet types
output "app_subnet_ids" {
  description = "List of app subnet IDs (same as private for this module)"
  value = [
    for idx, subnet in aws_subnet.private : subnet.id
    if var.subnet_types[idx] == "private"
  ]
}

output "transit_gateway_subnet_ids" {
  description = "List of transit gateway subnet IDs (using private subnets)"
  value = [
    for idx, subnet in aws_subnet.private : subnet.id
    if var.subnet_types[idx] == "private"
  ]
}

# Route table outputs
output "private_route_table_ids" {
  description = "List of private route table IDs"
  value       = aws_route_table.private[*].id
}

output "public_route_table_ids" {
  description = "List of public route table IDs"
  value       = aws_route_table.public[*].id
}

# REMOVE these outputs since the resources don't exist in main.tf:
# output "flow_log_id" {
#   description = "Flow Log ID"
#   value       = try(aws_flow_log.main[0].id, null)
# }

# output "private_zone_id" {
#   description = "Route53 private zone ID"
#   value       = try(aws_route53_zone.private[0].zone_id, null)
# }

# Add this output only if you add Route53 zone creation to main.tf
# Otherwise, remove any references to private_zone_id in your environment config
