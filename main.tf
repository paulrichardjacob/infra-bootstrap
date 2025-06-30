provider "aws" {
  region  = "eu-west-1"
  profile = "default"
}

resource "aws_instance" "genai_vm" {
  ami           = "ami-007e2167d974c08d6"  # ✅ Ubuntu 24.04 ARM64 in eu-west-1
  instance_type = "t4g.small"
  key_name = "genai-key"

  tags = {
    Name = "genai-vm"
  }
}
