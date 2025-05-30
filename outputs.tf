output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = data.aws_vpc.main.cidr_block
}

output "vpc_arn" {
  description = "ARN of the VPC"
  value       = aws_vpc.main.arn
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}

output "subnet_ids" {
  description = "List of subnet IDs"
  value       = aws_subnet.private[*].id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value = [
    for i, type in var.subnet_types :
    aws_subnet.private[i].id if type == "public"
  ]
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value = [
    for i, type in var.subnet_types :
    aws_subnet.private[i].id if type == "private"
  ]
}

output "subnet_cidrs" {
  description = "List of subnet CIDR blocks"
  value       = aws_subnet.private[*].cidr_block
}

output "public_route_table_id" {
  description = "ID of the public route table"
  value       = length(aws_route_table.public) > 0 ? aws_route_table.public[0].id : null
}

output "private_route_table_ids" {
  description = "List of private route table IDs"
  value       = aws_route_table.private[*].id
}

output "availability_zones" {
  description = "List of availability zones used"
  value       = var.availability_zones
}

output "vpc_main_route_table_id" {
  description = "ID of the main route table"
  value       = aws_vpc.main.main_route_table_id
}

output "vpc_default_security_group_id" {
  description = "ID of the default security group"
  value       = aws_vpc.main.default_security_group_id
}
