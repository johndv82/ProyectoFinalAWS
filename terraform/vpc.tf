resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags       = { Name = "${var.project}-vpc" }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "${var.project}-igw" }
}


resource "aws_subnet" "public" {
  count                   = length(var.public_subnet_cidrs)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidrs[count.index]
  map_public_ip_on_launch = true
  tags                    = { Name = "${var.project}-public-${count.index + 1}" }
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "${var.project}-public-rt" }
}


resource "aws_route_table_association" "pub_assoc" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}


resource "aws_security_group" "alb_sg" {
  name        = "${var.project}-alb-sg"
  description = "Allow HTTP from anywhere"
  vpc_id      = aws_vpc.main.id


  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


# ===============================================
# SECURITY GROUP - Permitir tráfico público al puerto 3000
# ===============================================
resource "aws_security_group" "ecs_sg" {
  name        = "${var.project}-sg"
  description = "Allow inbound traffic for Node.js app"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow HTTP traffic"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Permite tráfico desde cualquier IP
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project}-sg"
  }
}
