provider "aws" {
  access_key = ""
  secret_key = ""
  #Enter your access key and secret key
  region     = var.region #default eu-north-1 for me
}

data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]
filter {
    name   = "architecture"
    values = ["x86_64"]
  }
filter {
    name   = "image-type"
    values = ["machine"]
  }
filter {
    name   = "is-public"
    values = ["true"]
  }
filter {
    name   = "state"
    values = ["available"]
  }
name_regex = "^amzn2-ami-hvm-2.0*"
}
# ---------------------
# Custom security group
# ---------------------
resource "aws_security_group" "instance" {
  name = "terraform-security-group"
  #Enter your IP-subnet for connection
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["192.162.8.46/32"]
  }
  ingress {
    from_port   = 8088
    to_port     = 8088
    protocol    = "tcp"
    cidr_blocks = ["192.162.8.46/32"]
  }
  ingress {
    from_port   = 9870
    to_port     = 9870
    protocol    = "tcp"
    cidr_blocks = ["192.162.8.46/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "hadoop-docker"
  }
}
#---------------------------------
# Render userdata
#---------------------------------
data "template_file" "user_data" {
  template = file("userdata.sh")
}
#---------------------------------
# Start resource ec2-instance
#---------------------------------
resource "aws_instance" "hadoop-docker" {
  ami             = data.aws_ami.amazon-linux-2.id
  instance_type   = "t3.micro"
  #Enter your own key
  key_name        = "Keyname"
  security_groups = ["${aws_security_group.instance.name}"]
  user_data       = data.template_file.user_data.rendered
  tags = {
    Name = "hadoop cluster"
  }
}