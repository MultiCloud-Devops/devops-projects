#----------------------------
# VPC Outputs
#----------------------------
output "vpc_id" {
  description = "VPC id"
  value       = aws_vpc.tfsp_vpc.id
}

output "vpc_private_subnets" {
  description = "List of VPC private subnets"
  value       = [for subnet in aws_subnet.tfsp_private_subnets : subnet.id]
}

output "vpc_public_subnets" {
  description = "List of VPC public subnets"
  value       = [for subnet in aws_subnet.tfsp_public_subnets : subnet.id]
}
