resource "aws_instance" "bta" {
  ami           = "ami-04b70fa74e45c3917"
  instance_type = "t2.medium"

  tags = {
    Name = "bta"
  }
}
