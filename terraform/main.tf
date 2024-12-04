# Defines resources like EC2 instance, security group, and key pair.
provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "airflow_sg" {
  name        = "airflow_sg"
  description = "Allow HTTP and SSH access"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
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

resource "aws_key_pair" "airflow_key" {
  key_name   = "airflow_key"
  public_key = file("~/.ssh/id_rsa.pub")
}

resource "aws_instance" "airflow" {
  ami           = "ami-0c02fb55956c7d316" # Ubuntu 20.04 LTS
  instance_type = "t2.micro"
  key_name      = aws_key_pair.airflow_key.key_name
  security_groups = [aws_security_group.airflow_sg.name]

  user_data = file("${path.module}/user-data.sh")

  tags = {
    Name = "AirflowInstance"
  }
}

output "airflow_instance_public_ip" {
  value = aws_instance.airflow.public_ip
}