resource "aws_security_group" "terraformer_security_web" {
  name        = var.terraformer_security_web_name
  description = "Regras de firewall para acessar a rede terraformer web."
  vpc_id      = aws_vpc.rede_terraformer.id


  dynamic "ingress" {

    for_each = var.web_security_group_ingresses

    content {
      description      = ingress.value["description"]
      from_port        = ingress.value["from_port"]
      to_port          = ingress.value["to_port"]
      protocol         = ingress.value["protocol"]
      cidr_blocks      = ingress.value["cidr_blocks"]
      ipv6_cidr_blocks = ingress.value["ipv6_cidr_blocks"]
    }
  }

  dynamic "egress" {

    for_each = var.web_security_group_egresses
    content {
      description      = egress.value["description"]
      from_port        = egress.value["from_port"]
      to_port          = egress.value["to_port"]
      protocol         = egress.value["protocol"]
      cidr_blocks      = egress.value["cidr_blocks"]
      ipv6_cidr_blocks = egress.value["ipv6_cidr_blocks"]
    }
  }

  tags = {
    Name = var.terraformer_security_web_name
  }

}









resource "aws_network_acl" "terraformer_web_nacl" {
  vpc_id     = aws_vpc.rede_terraformer.id
  subnet_ids = [aws_subnet.subrede_publica.id]


  dynamic "ingress" {
    for_each = var.terraformer_web_nacl_ingress
    content {
      protocol   = ingress.value["protocol"]
      rule_no    = ingress.value["rule_no"]
      action     = ingress.value["action"]
      cidr_block = ingress.value["cidr_block"]
      from_port  = ingress.value["from_port"]
      to_port    = ingress.value["to_port"]
    }
  }


  dynamic "egress" {
    for_each = var.terraformer_web_nacl_egress
    content {
      protocol   = egress.value["protocol"]
      rule_no    = egress.value["rule_no"]
      action     = egress.value["action"]
      cidr_block = egress.value["cidr_block"]
      from_port  = egress.value["from_port"]
      to_port    = egress.value["to_port"]
    }
  }



  tags = {
    Name = var.terraformer_web_nacl_name
  }
}









resource "aws_security_group" "terraformer_security_datasource" {
  name        = var.terraformer_security_datasource_name
  description = "Regras de firewall para gerenciar o acesso de rede de dados."
  vpc_id      = aws_vpc.rede_terraformer.id


  ingress {
    description     = "Datasource conect."
    from_port       = 27017
    to_port         = 27017
    protocol        = "tcp"
    security_groups = [aws_security_group.terraformer_security_web.id] #Allow access from this security group.
    # cidr_blocks      = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
  }


  ingress {
    description      = "Acesso SSH."
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.rede_terraformer.cidr_block] #Access only from intern web.
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "Acesso HTTP."
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [aws_vpc.rede_terraformer.cidr_block] #Access only from intern web.
    ipv6_cidr_blocks = ["::/0"]
  }


  dynamic "egress" {
    for_each = var.terraformer_security_datasource_egress
    content {
      description      = egress.value["description"]
      from_port        = egress.value["from_port"]
      to_port          = egress.value["to_port"]
      protocol         = egress.value["protocol"]
      cidr_blocks      = egress.value["cidr_blocks"]
      ipv6_cidr_blocks = egress.value["ipv6_cidr_blocks"]
    }
  }

  tags = {
    Name = var.terraformer_security_datasource_name
  }

}



resource "aws_network_acl" "terraformer_data_nacl" {
  vpc_id     = aws_vpc.rede_terraformer.id
  subnet_ids = [aws_subnet.subrede_particular.id]


  dynamic "ingress" {
    for_each = var.terraformer_data_nacl_ingress
    content {
      protocol   = ingress.value["protocol"]
      rule_no    = ingress.value["rule_no"]
      action     = ingress.value["action"]
      cidr_block = ingress.value["cidr_block"]
      from_port  = ingress.value["from_port"]
      to_port    = ingress.value["to_port"]
    }
  }



  dynamic "egress" {
    for_each = var.terraformer_data_nacl_egress
    content {
      protocol   = egress.value["protocol"]
      rule_no    = egress.value["rule_no"]
      action     = egress.value["action"]
      cidr_block = egress.value["cidr_block"]
      from_port  = egress.value["from_port"]
      to_port    = egress.value["to_port"]
    }
  }

  tags = {
    Name = var.terraformer_data_nacl_name
  }

}