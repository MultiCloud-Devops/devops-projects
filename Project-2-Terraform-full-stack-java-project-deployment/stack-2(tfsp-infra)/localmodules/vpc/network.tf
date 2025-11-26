#--------------------------------------
# VPC
#--------------------------------------
resource "aws_vpc" "tfsp_vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "tfsp-${var.env_name}-vpc"
  }

}

#--------------------------------------
# Internet Gateway 
#--------------------------------------
resource "aws_internet_gateway" "tfsp_igw" {
  vpc_id = aws_vpc.tfsp_vpc.id
  tags = {
    Name = "tfsp-${var.env_name}-igw"
  }
}

#--------------------------------------
# Public Subnets
#-------------------------------------- 
resource "aws_subnet" "tfsp_public_subnets" {
  count             = local.public_subnet_count
  vpc_id            = aws_vpc.tfsp_vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 8, count.index + 1)
  availability_zone = local.az_names[count.index]

  tags = {
    Name = "tfsp-${var.env_name}-public-subnet-${count.index + 1}"
  }
}

#--------------------------------------
# Private Subnets 
#--------------------------------------
resource "aws_subnet" "tfsp_private_subnets" {
  count             = local.private_subnet_count
  vpc_id            = aws_vpc.tfsp_vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 8, count.index + 101)
  availability_zone = local.az_names[count.index]

  tags = {
    Name = "tfsp-${var.env_name}-private-subnet-${count.index + 1}"
  }

}

#--------------------------------------
# Elastic IP for NAT Gateway
#--------------------------------------
resource "aws_eip" "tfsp_nat_eip" {
  domain = "vpc"

  tags = {
    Name = "tfsp-${var.env_name}-nat-eip"
  }
}

#--------------------------------------
# NAT Gateway 
#--------------------------------------
resource "aws_nat_gateway" "tfsp_nat_gw" {
  allocation_id = aws_eip.tfsp_nat_eip.id
  subnet_id     = aws_subnet.tfsp_public_subnets[0].id

  tags = {
    Name = "tfsp-${var.env_name}-nat-gw"
  }

  depends_on = [aws_internet_gateway.tfsp_igw]
}

#--------------------------------------
# Public Route Table  
#--------------------------------------
resource "aws_route_table" "tfsp_public_rt" {
  vpc_id = aws_vpc.tfsp_vpc.id

  tags = {
    Name = "tfsp-${var.env_name}-public-rt"
  }
}
#--------------------------------------
# Public Route Table IGW Route  
#--------------------------------------
resource "aws_route" "tfsp_public_route" {
  route_table_id         = aws_route_table.tfsp_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.tfsp_igw.id
}
#--------------------------------------
# Public Route Table Association
#--------------------------------------
resource "aws_route_table_association" "tfsp_public_rt_assoc" {
  count          = local.public_subnet_count
  subnet_id      = aws_subnet.tfsp_public_subnets[count.index].id
  route_table_id = aws_route_table.tfsp_public_rt.id
}

#--------------------------------------
# Private Route Table
#--------------------------------------
resource "aws_route_table" "tfsp_private_rt" {
  vpc_id = aws_vpc.tfsp_vpc.id

  tags = {
    Name = "tfsp-${var.env_name}-private-rt"
  }
}
#--------------------------------------
# Private Route Table NAT Gateway Route       
#--------------------------------------
resource "aws_route" "tfsp_private_route" {
  route_table_id         = aws_route_table.tfsp_private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.tfsp_nat_gw.id
}

#--------------------------------------
# Private Route Table Association
#--------------------------------------
resource "aws_route_table_association" "tfsp_private_rt_assoc" {
  count          = local.private_subnet_count
  subnet_id      = aws_subnet.tfsp_private_subnets[count.index].id
  route_table_id = aws_route_table.tfsp_private_rt.id
}
