resource "aws_instance" "bta" {
  ami                         = "ami-04b70fa74e45c3917"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.main_public.id
  key_name                    = aws_key_pair.bta.key_name
  associate_public_ip_address = true

  tags = {
    Name = "bta"
  }
}

resource "aws_key_pair" "bta" {
  key_name   = "bta.pem"
  public_key = file("bta_public.pem")
}

resource "aws_security_group" "bta" {
  name        = "bta"
  description = "bta"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 19132
    to_port     = 19132
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_network_interface_sg_attachment" "sg_attachment" {
  security_group_id    = aws_security_group.bta.id
  network_interface_id = aws_instance.bta.primary_network_interface_id
}
