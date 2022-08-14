### Transit infrastructure

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_organizations_organization" "org" {}

locals {
  name   = "Onpremises"
  region = var.region
}

################################################################################
# VPC section
################################################################################

#
## Main VPC
#
resource "aws_vpc" "onprem" {
  cidr_block            = var.cidr_block
  instance_tenancy      = "default"
  
  enable_dns_support    = true
  enable_dns_hostnames  = true

  tags = {
	#Name                = var.vpc_name
	Name                = "Onpremises"
	Project             = "Azure-AWS"
	CostCenter          = "AoD"
  }
}

#
## Public Subnets
#
resource "aws_subnet" "PublicSubnet1a" {
  cidr_block = var.public_subnet_1a_cidr
  map_public_ip_on_launch = false
  vpc_id = aws_vpc.onprem.id
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
	  Name = "Public Subnet AZ 1a"
  }
}

resource "aws_subnet" "PublicSubnet1c" {
  cidr_block = var.public_subnet_1c_cidr
  map_public_ip_on_launch = false
  vpc_id = aws_vpc.onprem.id
  availability_zone = data.aws_availability_zones.available.names[2]

  tags = {
	  Name = "Public Subnet AZ 1c"
  }
}
#
## Route tables - Public
#
resource "aws_route_table" "RouteTablePublic" {
  vpc_id = aws_vpc.onprem.id
  depends_on = [ aws_internet_gateway.Igw ]

  tags = {
	  Name         = "Public Route Table"
  }

  # Internet
  route {
	cidr_block     = "0.0.0.0/0"
	gateway_id     = aws_internet_gateway.Igw.id
  }
}
#
## Route tables associations - Public
#
resource "aws_route_table_association" "AssociationForRouteTablePublic1a" {
  subnet_id      = aws_subnet.PublicSubnet1a.id
  route_table_id = aws_route_table.RouteTablePublic.id
}

resource "aws_route_table_association" "AssociationForRouteTablePubli1c" {
  subnet_id      = aws_subnet.PublicSubnet1c.id
  route_table_id = aws_route_table.RouteTablePublic.id
}
#
## Internet Gateway
#
resource "aws_internet_gateway" "Igw" {
  vpc_id = aws_vpc.onprem .id
}
#
## Elastic IP for Cisco CSR 1000v in 1a
#
resource "aws_eip" "EipForCiscoGw1a" {
  tags = {
    Name        = "CiscoCSR1000v-1a"
    CostCenter  = "AoD"
  }
}

## Elastic IP for Cisco CSR 1000v in 1b
#
resource "aws_eip" "EipForCiscoGw1c" {
  tags = {
    Name        = "CiscoCSR1000v-1c"
    CostCenter  = "AoD"
  }
}


#### Placeholder for future private subnets
# resource "aws_subnet" "PrivateSubnet1a" {
#   cidr_block = var.private_subnet_1a_cidr
#   map_public_ip_on_launch = false
#   vpc_id = aws_vpc.onprem.id
#   availability_zone = data.aws_availability_zones.available.names[0]

#   tags = {
# 	Name = "Private Subnet AZ 1a"
#   }
# }

# resource "aws_subnet" "PrivateSubnet1c" {
#   cidr_block = var.private_subnet_1c_cidr
#   map_public_ip_on_launch = false
#   vpc_id = aws_vpc.onprem.id
#   availability_zone = data.aws_availability_zones.available.names[2]

#   tags = {
# 	Name = "Private Subnet AZ 1c"
#   }
# }
