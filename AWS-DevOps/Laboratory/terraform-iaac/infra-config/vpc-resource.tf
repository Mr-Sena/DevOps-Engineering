resource "aws_vpc" "rede_terraformer" {
  cidr_block = var.terraformer_vpc_cidr_block

  tags = {
    Name = var.terraformer_vpc_name
  }
}



resource "aws_subnet" "subrede_publica" {
  vpc_id     = aws_vpc.rede_terraformer.id
  cidr_block = var.terraformer_public_subnet_cidr_block
  tags = {
    Name = var.terraformer_public_subnet_name
  }
}



resource "aws_subnet" "subrede_particular" {
  vpc_id     = aws_vpc.rede_terraformer.id
  cidr_block = var.terraformer_private_subnet_cidr_block
  tags = {
    Name = var.terraformer_private_subnet_name
  }
}



resource "aws_internet_gateway" "terraformer_igw" {

  tags = {
    Name = var.terraformer_igw_name
  }
}

resource "aws_internet_gateway_attachment" "terraformer_link_igw" {
  internet_gateway_id = aws_internet_gateway.terraformer_igw.id
  vpc_id              = aws_vpc.rede_terraformer.id
}






resource "aws_eip" "terraformer_nat_eip" {

  tags = {
    Name = var.terraformer_nat_eip_name
  }

  depends_on = [aws_internet_gateway.terraformer_igw]
}


resource "aws_nat_gateway" "terraformer_nat_gateway" {
  allocation_id = aws_eip.terraformer_nat_eip.id
  subnet_id     = aws_subnet.subrede_publica.id

  tags = {
    Name = var.terraformer_nat_gtw_name
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.terraformer_igw]
}





resource "aws_route_table" "terraformer_public_route_table" {
  vpc_id = aws_vpc.rede_terraformer.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.terraformer_igw.id
  }

  tags = {
    Name = var.public_route_table_name
  }
}




resource "aws_route_table_association" "link_public_route_table" {
  subnet_id      = aws_subnet.subrede_publica.id
  route_table_id = aws_route_table.terraformer_public_route_table.id
}






resource "aws_route_table" "terraformer_private_route_table" {
  vpc_id = aws_vpc.rede_terraformer.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.terraformer_nat_gateway.id
  }

  tags = {
    Name = var.private_route_table_name
  }
}




resource "aws_route_table_association" "link_private_route_table" {
  subnet_id      = aws_subnet.subrede_particular.id
  route_table_id = aws_route_table.terraformer_private_route_table.id
}