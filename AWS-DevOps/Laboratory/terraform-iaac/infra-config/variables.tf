##Variávies de ambiente.


variable "region_area" {
  type        = string
  default     = "us-east-1"
  description = "Localidade de área do datacenter."
}

# Remember: Em caso de variáveis que não possui um valor
# default, criar um arquivo .tfvars para definir os parâmetros.


#
#
# Variávies de VPC.
#
#

variable "terraformer_vpc_name" {
  type        = string
  default     = "terraformer-vpc"
  description = "Nome de rede VPC."
}


variable "terraformer_vpc_cidr_block" {
  type        = string
  default     = "10.0.0.0/16"
  description = "VPC CIDR Block"
}



variable "terraformer_public_subnet_name" {
  type        = string
  default     = "subrede-publica"
  description = "Nome da subnet publica"
}


variable "terraformer_public_subnet_cidr_block" {
  type        = string
  default     = "10.0.0.0/24"
  description = "cidr block da subrede publica"
}



variable "terraformer_private_subnet_name" {
  type        = string
  default     = "subrede-particular"
  description = "Nome da subrede particular."
}


variable "terraformer_private_subnet_cidr_block" {
  type        = string
  default     = "10.0.1.0/24"
  description = "cidr block da subnet particular."
}


variable "terraformer_igw_name" {
  type        = string
  default     = "terraformer-igw"
  description = "Nome de internet gateway."
}




variable "terraformer_nat_eip_name" {
  type        = string
  default     = "terraformer-nat-eip"
  description = "Nome do elastic ip vinculado ao nat gateway."
}



variable "terraformer_nat_gtw_name" {
  type        = string
  default     = "terraformer-nat-gateway"
  description = "Nome de nat gateway."
}



variable "public_route_table_name" {
  type        = string
  default     = "terraformer-public-route-table"
  description = "Nome da route table publica"
}


variable "private_route_table_name" {
  type        = string
  default     = "terraformer-private-route-table"
  description = "Nome da route table publica"
}



#
#
#  Variáveis das EC2
#
#

variable "kpair_ssh_name" {
  type        = string
  default     = "access-key-ssh"
  description = "SSH access key name."
}


variable "kpair_ssh_file_path" {
  type        = string
  default     = "~/.ssh/id_rsa.pub" # Use host public ssh key for create the key pair.
  description = "SSH access key path"
}



variable "ec2_ami" {
  type        = string
  default     = "ami-0c7217cdde317cfec" ## System Ubuntu image id.
  description = "System image id."
}


variable "web_ec2_instance_name" {
  type        = string
  default     = "web-ec2-instance"
  description = "The web server ec2 instance name"
}


variable "web_ec2_instance_type" {
  type        = string
  default     = "t2.micro"
  description = "description"
}



variable "db_ec2_instance_name" {
  type        = string
  default     = "data-ec2-instance"
  description = "description"
}


variable "db_ec2_instance_type" {
  type        = string
  default     = "t2.micro"
  description = "description"
}




#
#
#  Variáveis de segurança
#
#

variable "terraformer_security_web_name" {
  type        = string
  default     = "terraformer-security-web"
  description = "Web service security group."
}


variable "web_security_group_ingresses" {
  default = [
    {
      description      = "Acesso HTTP.",
      from_port        = 80,
      to_port          = 80,
      protocol         = "tcp",
      cidr_blocks      = ["0.0.0.0/0"],
      ipv6_cidr_blocks = ["::/0"]
    },
    {
      description      = "Acesso HTTPs."
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    },
    {
      description      = "Acesso ssh."
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  ]
  description = "Regras de acesso para permitir conectar o web service."
}



variable "web_security_group_egresses" {
  default = [
    {
      description      = "Acesso HTTP."
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    },
    {
      description      = "Acesso HTTPs."
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    },
    {
      description      = "Acesso DNS."
      from_port        = 53
      to_port          = 53
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    },
    {
      description      = "Acesso DNS."
      from_port        = 53
      to_port          = 53
      protocol         = "udp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    },
    {
      description      = "Acesso SSH."
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    },
    {
      description      = "Connect database."
      from_port        = 27017
      to_port          = 27017
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  ]
  description = "Regras de rede para permitir enviar o acesso externo."
}



variable "terraformer_web_nacl_name" {
  type        = string
  default     = "terraformer-web-nacl"
  description = "Nome da Network ACL para a subrede publica."
}




variable "terraformer_web_nacl_ingress" {
  default = [
    # HTTP
    {
      protocol   = "tcp"
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 80
      to_port    = 80
    },
    # HTTPs
    {
      protocol   = "tcp"
      rule_no    = 110
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 443
      to_port    = 443
    },
    # SSH
    {
      protocol   = "tcp"
      rule_no    = 120
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 22
      to_port    = 22
    },
    # Portas DNS
    {
      protocol   = "tcp"
      rule_no    = 130
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 53
      to_port    = 53
    },
    # Portas DNS
    {
      protocol   = "udp"
      rule_no    = 135
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 53
      to_port    = 53
    },
    # Portas efemeras
    {
      protocol   = "tcp"
      rule_no    = 140
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 1024
      to_port    = 65535
    },
  ]
  description = "Regras de ingress da Network ACL para a subnet publica"
}



variable "terraformer_web_nacl_egress" {
  default = [
    # Portas efemeras
    {
      protocol   = "tcp"
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 1024
      to_port    = 65535
    },
    # Portas HTTP
    {
      protocol   = "tcp"
      rule_no    = 110
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 80
      to_port    = 80
    },
    # Portas HTTPs
    {
      protocol   = "tcp"
      rule_no    = 120
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 443
      to_port    = 443
    },
    # Portas DNS
    {
      protocol   = "tcp"
      rule_no    = 130
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 53
      to_port    = 53
    },
    # Portas DNS
    {
      protocol   = "udp"
      rule_no    = 135
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 53
      to_port    = 53
    },
    # Portas SSH
    {
      protocol   = "tcp"
      rule_no    = 140
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 22
      to_port    = 22
    }
  ]
  description = "Regras de egress da Network ACL para a subrede particular"
}


variable "terraformer_security_datasource_name" {
  type        = string
  default     = "terraformer-security-datasource"
  description = "Security group name datasource."
}

variable "terraformer_security_datasource_egress" {

  default = [
    {
      description      = "Acesso HTTP."
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    },
    {
      description      = "Acesso HTTPs."
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    },
    {
      description      = "Acesso DNS."
      from_port        = 53
      to_port          = 53
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    },
    {
      description      = "Acesso DNS."
      from_port        = 53
      to_port          = 53
      protocol         = "udp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  ]
  description = "Grupo de regras para enviar o acesso para o lado externo da rede de dados."
}


variable "terraformer_data_nacl_name" {
  type    = string
  default = "terraformer-data-nacl"
}


variable "terraformer_data_nacl_ingress" {

  default = [
    # Acesso à base de dados: 
    {
      protocol   = "tcp"
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 27017
      to_port    = 27017
    },
    # SSH
    {
      protocol   = "tcp"
      rule_no    = 110
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 22
      to_port    = 22
    },
    # Portas Efemeras
    {
      protocol   = "tcp"
      rule_no    = 120
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 1024
      to_port    = 65535
    }
  ]
  description = "Regras de ingress da Network ACL para a subrede de dados."
}


variable "terraformer_data_nacl_egress" {

  default = [
    # Portas Efemeras
    {
      protocol   = "tcp"
      rule_no    = 100
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 1024
      to_port    = 65535
    },
    # Portas HTTP
    {
      protocol   = "tcp"
      rule_no    = 110
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 80
      to_port    = 80
    },
    # Portas HTTPs
    {
      protocol   = "tcp"
      rule_no    = 120
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 443
      to_port    = 443
    },
    # Portas DNS
    {
      protocol   = "tcp"
      rule_no    = 130
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 53
      to_port    = 53
    },
    # Portas DNS
    {
      protocol   = "udp"
      rule_no    = 140
      action     = "allow"
      cidr_block = "0.0.0.0/0"
      from_port  = 53
      to_port    = 53
    }
  ]

  description = "Regras de ingress da Network ACL para a subrede de dados."
}