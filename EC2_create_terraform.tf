resource "aws_key_pair" "my_ssh_key" {
  key_name   = "terra-key-auto"
  public_key = file("/home/ubuntu/terra-key-auto.pub")
}

resource "aws_default_vpc" "default" {
}

resource "aws_security_group" "my_sg" {
  name        = "yash-sg"
  description = "This is a super security group"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP access"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }
}

resource "aws_instance" "my_instance" {
  ami           = "ami-0862be96e41dcbf74"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.my_ssh_key.key_name
  vpc_security_group_ids = [aws_security_group.my_sg.id]

  tags = {
    Name = "my-auto-server"
  }
}

output "my_ec2_ip" {
  value = aws_instance.my_instance.public_ip
}
