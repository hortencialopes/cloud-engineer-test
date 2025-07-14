# A security group to allow SSH traffic in and all traffic out.
resource "aws_security_group" "client_sg" {
  name        = "${var.project_name}-client-ec2-sg"
  description = "Allow SSH and all outbound traffic for the client instance"
  vpc_id      = data.terraform_remote_state.network.outputs.networking_output.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["189.69.9.85/32"] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-client-ec2-sg"
  }
}

# Find the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# The EC2 instance resource
resource "aws_instance" "grpc_client" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro" 
  subnet_id     = data.terraform_remote_state.network.outputs.networking_output.public_subnet_az1_id
  vpc_security_group_ids = [aws_security_group.client_sg.id]
  associate_public_ip_address = true
  
  key_name = "horta-ec2-key-pair" 

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y python3 git
              pip3 install grpcio pytz
              EOF

  tags = {
    Name = "${var.project_name} gRPC Client"
  }
}

output "client_instance_public_ip" {
  description = "The public IP address of the gRPC client EC2 instance."
  value       = aws_instance.grpc_client.public_ip
}