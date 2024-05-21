resource "aws_instance" "bta" {
  ami           = "ami-04b70fa74e45c3917"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.main_public.id
  key_name = aws_key_pair.bta.key_name
  associate_public_ip_address = true

  tags = {
    Name = "bta"
  }
}

resource "aws_key_pair" "bta" {
  key_name = "bta.pem"
  public_key = file("bta_public.pem")
}


