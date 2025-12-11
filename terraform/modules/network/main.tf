# Busca as duas primeiras Availability Zones disponíveis (para alta disponibilidade)
data "aws_availability_zones" "available" {
  state = "available"
}


# VPC

resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "teddy-vpc"
  }
}

# Internet Gateway (IGW) para acesso à Internet

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "teddy-igw"
  }
}


# Subnet pública e em 2 AZs diferentes
# Subnets públicas para Load Balancer e acesso SSH

resource "aws_subnet" "public" {
  count                   = 2 # Cria 2 subnets em AZs diferentes
  vpc_id                  = aws_vpc.main.id

  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "teddy-subnet-public-${data.aws_availability_zones.available.names[count.index]}"
  }
}

# Subnets privadas para tasks do Fargate
resource "aws_subnet" "private" {
  count             = 2 # Cria 2 subnets em AZs diferentes
  vpc_id            = aws_vpc.main.id

  
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + 2)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "teddy-subnet-private-${data.aws_availability_zones.available.names[count.index]}"
  }
}


# Nat Gateway (Saida para Internet das subnets privadas)

# IP Elástico (EIP) para o NAT Gateway
resource "aws_eip" "nat" {
  tags = {
    Name = "teddy-nat-eip"
  }
}

# NAT Gateway (instalado na primeira subnet piblica)
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id # Fica na primeira subnet pública
  tags = {
    Name = "teddy-nat-gw"
  }
  depends_on = [aws_internet_gateway.igw]
}


# Route tables

# Rota pública (aponta para o IGW)
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "teddy-route-table-publica"
  }
}

# Associação das duas subnets públicas para as route table pública
resource "aws_route_table_association" "associacao_rota_publica" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Rota Privada (aponta para o NAT Gateway)
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }
  tags = {
    Name = "teddy-route-table-privada"
  }
}

# Associação das duas subnets privadas para a route table privada
resource "aws_route_table_association" "associacao_rota_privada" {
  count          = length(aws_subnet.private)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}