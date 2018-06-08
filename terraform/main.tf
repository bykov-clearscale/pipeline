provider "aws" {
  region = "us-west-2"
}


resource "aws_security_group" "es" {
  name        = "es-sg"
  description = "Security group to access elasticsearch cluster"
  vpc_id      = "vpc-xxxxxx"


  ingress {
    description = "Intra-cluster communications (API)"
    from_port       = 9200
    to_port         = 9200
    protocol        = "TCP"
    cidr_blocks     = [ "0.0.0.0/0"]
    self = true
  }

  ingress {
    description     = "SSH access from bastion and vpn."
    from_port       = 22
    to_port         = 22
    protocol        = "TCP"
    self            = true
    cidr_blocks     = [ "0.0.0.0/0"]
  }

  ingress {
    description = "Intra-cluster communications (ZEN)"
    from_port   = 9300
    to_port     = 9300
    protocol    = "TCP"
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
