locals {
  ec2_ami = var.ec2_ami
}

resource "aws_key_pair" "access_key_ssh" {
  key_name   = var.kpair_ssh_name
  public_key = file(var.kpair_ssh_file_path)
}



resource "aws_instance" "web_ec2_instance" {

  ami                         = local.ec2_ami
  instance_type               = var.web_ec2_instance_type
  subnet_id                   = aws_subnet.subrede_publica.id
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.terraformer_security_web.id]
  key_name                    = aws_key_pair.access_key_ssh.key_name

  user_data = file("./docker-install.sh") // Script to automate the container plataform.

  tags = {
    Name = "web-ec2-instance"
  }
}


## Detalhe: o processo para executar o aplicativo, e conectar o acesso à base de dados deverá ser efetuado manualmente. [container-configure.txt] ##


resource "aws_instance" "data_ec2_instance" {

  ami                    = local.ec2_ami
  instance_type          = var.db_ec2_instance_type
  subnet_id              = aws_subnet.subrede_particular.id
  vpc_security_group_ids = [aws_security_group.terraformer_security_datasource.id]
  key_name               = aws_key_pair.access_key_ssh.key_name
  user_data              = file("./docker-install.sh")

  tags = {
    Name = "data-ec2-instance"
  }
}









output "web_instance_ip" {

  value = aws_instance.web_ec2_instance.public_ip
}

output "data_instance_ip" {

  value = aws_instance.data_ec2_instance.private_ip
}