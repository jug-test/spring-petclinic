provider "aws" {
  region = "eu-central-1"
}

resource "tls_private_key" "pkey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "kp" {
  key_name   = "jug_key_name"
  public_key = tls_private_key.pkey.public_key_openssh
}

  /*provisioner "local-exec" {
    command = "echo '${tls_private_key.pkey.private_key_pem}' > myKey.pem"
  }
}*/

resource "aws_instance" "T2SMALL" {
  ami                    = "ami-05f7491af5eef733a"
  instance_type          = "t2.small"
  key_name               = aws_key_pair.kp.key_name
  vpc_security_group_ids = [aws_security_group.For_Jenkins.id]
}

resource "aws_eip" "my_static_ip" {
instance = aws_instance.T2SMALL.id
}

resource "aws_instance" "Target" {
  ami                    = "ami-05f7491af5eef733a"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.kp.key_name
  vpc_security_group_ids = [aws_security_group.For_Target.id]
}

resource "aws_instance" "Target2" {
  ami                    = "ami-05f7491af5eef733a"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.kp.key_name
  vpc_security_group_ids = [aws_security_group.For_Target.id]
}

resource "aws_security_group" "For_Jenkins" {
  name        = "Jenkins Security Group"
  description = "Security Group for Jenkins"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["185.102.185.209/32"]
  }
  

  ingress {
    from_port   = 8082
    to_port     = 8082
    protocol    = "tcp"
    cidr_blocks = ["185.102.185.209/32"]
  }
  

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "For_Target" {
  name        = "Target Security Group"
  description = "Security Group for Target"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["185.102.185.209/32"]
  }
  
  ingress {
    from_port   = 22
    to_port     = 22
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

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

resource "aws_ecrpublic_repository" "juger_pet" {
  provider = aws.us_east_1
  repository_name = "juger"
  catalog_data {
    about_text = ""
    architectures = ["x86-64"]
    description = "Petclinic images"
    operating_systems = ["Linux"]
    usage_text = "Petlclinic"
  }
}
