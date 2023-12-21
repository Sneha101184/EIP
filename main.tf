# Launch an EC2 Instance
provider "aws" {
  region = "eu-west-2" 
}
resource "aws_instance" "EIP-Instance" {
  ami           = "ami-0b1b00f4f0d09d131" 
  instance_type = "t2.micro"
  key_name = "terraformkeypair" 
          
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<html><h1>Hello from Terraform EC2</h1></html>" > /var/www/html/index.html
  EOF

  tags = {
    Name = "EIP-Instance"
  }
}
# Define EIP
resource "aws_eip" "Task-EIP" {
    instance = aws_instance.EIP-Instance.id
}
# Associate EIP
resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.EIP-Instance.id
  allocation_id = aws_eip.Task-EIP.id
}