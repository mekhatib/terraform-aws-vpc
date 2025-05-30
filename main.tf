# VPC with IPAM allocation
resource "aws_vpc" "main" {
  # IPAM allocation for VPC
  ipv4_ipam_pool_id   = var.use_ipam ? var.ipam_pool_id : null
  ipv4_netmask_length = var.use_ipam ? var.vpc_netmask_length : null
  
  # Traditional CIDR block (if not using IPAM)
  cidr_block = var.use_ipam ? null : var.vpc_cidr
  
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-vpc"
    }
  )
}

# Data source to get the actual CIDR block after VPC creation
data "aws_vpc" "main" {
  id = aws_vpc.main.id
  depends_on = [aws_vpc.main]
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-igw"
    }
  )
}

# Subnets - Using calculated CIDR blocks from the actual VPC CIDR
resource "aws_subnet" "private" {
  count = length(var.availability_zones)
  vpc_id            = aws_vpc.main.id
  availability_zone = var.availability_zones[count.index]
  
  # Use the data source to get the actual CIDR block
  cidr_block = cidrsubnet(
    data.aws_vpc.main.cidr_block,  # ← Use data source instead
    var.subnet_newbits != null ? var.subnet_newbits : (
      var.use_ipam ? 
        (32 - var.vpc_netmask_length - 5) :  # For IPAM: calculate based on netmask
        (16 - tonumber(split("/", data.aws_vpc.main.cidr_block)[1]) + 11)  # For traditional CIDR
    ),
    count.index
  )
  
  map_public_ip_on_launch = var.subnet_types[count.index] == "public" ? true : false
  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-${var.subnet_types[count.index]}-subnet-${count.index + 1}"
      VLAN = var.vlan_tags[count.index]
      Type = var.subnet_types[count.index]
    }
  )
  depends_on = [aws_vpc.main, data.aws_vpc.main]
}

# Route Tables
resource "aws_route_table" "private" {
  count = length([for k, v in var.subnet_types : k if v == "private"])

  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-rt-private-${count.index + 1}"
    }
  )
}

resource "aws_route_table" "public" {
  count = length([for k, v in var.subnet_types : k if v == "public"]) > 0 ? 1 : 0

  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      Name = "${var.project_name}-${var.environment}-rt-public"
    }
  )
}

# Public route
resource "aws_route" "public_internet" {
  count = length([for k, v in var.subnet_types : k if v == "public"]) > 0 ? 1 : 0

  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

# Route Table Associations
resource "aws_route_table_association" "subnet" {
  count = length(var.availability_zones)

  subnet_id = aws_subnet.private[count.index].id
  route_table_id = var.subnet_types[count.index] == "public" ? (
    length(aws_route_table.public) > 0 ? aws_route_table.public[0].id : aws_route_table.private[0].id
  ) : element(aws_route_table.private[*].id, count.index)
}

# ... rest of the VPC module code (Flow Logs, etc.)
