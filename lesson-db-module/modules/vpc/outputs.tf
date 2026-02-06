# ID of the created VPC
output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

# List of public subnet IDs
output "public_subnet_ids" {
  description = "List of IDs of the public subnets"
  value       = [for subnet in aws_subnet.public : subnet.id]
}

# List of private subnet IDs
output "private_subnet_ids" {
  description = "List of IDs of the private subnets"
  value       = [for subnet in aws_subnet.private : subnet.id]
}

# ID of the Internet Gateway
output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}

# IDs of the public route tables
output "public_route_table_ids" {
  description = "List of IDs of the public route tables"
  value       = [aws_route_table.public.id]
}

# IDs of the private route tables
output "private_route_table_ids" {
  description = "List of IDs of the private route tables"
  value       = [aws_route_table.private.id]
}

# ID of the NAT Gateway
output "nat_gateway_id" {
  description = "The ID of the NAT Gateway (for outbound access from private subnets)"
  value       = aws_nat_gateway.nat.id
}