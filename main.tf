provider "aws" {
  region = "us-east-1"  
}

resource "aws_s3_bucket" "static_site" {
  bucket = "tf-state-98ftyyyy"
  acl    = "public-read"
}

resource "aws_security_group" "web" {
  name_prefix = ""

  # Define security group rules (e.g., allow HTTP and HTTPS)
}

resource "aws_instance" "web_server" {
  ami           = "ami-00eeedc4036573771"  
  instance_type = "t2.micro"  

 
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update
              sudo apt install -y ansible
              # ... more setup here ...
              EOF

  # Define security group for the instance (allow SSH from your IP)
  vpc_security_group_ids = [aws_security_group.web.id]
}

resource "aws_lb" "web_lb" {
  name               = "web-lb"
  internal           = false
  load_balancer_type = "application"
  enable_deletion_protection = false
  subnets            = [subnet-0dbe6797d58649a43,subnet-0df820731e17c9390,subnet-0c423464d574ac275
]

  enable_http2 = true


  # Define security group for the ALB (allow HTTP and HTTPS)
  security_groups = [default]
}

resource "aws_lb_target_group" "web_target_group" {
  name     = "web-target-group"
  port     = 80
  protocol = "HTTP"

  # Define health check settings here
}

resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.web_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      status_code  = "200"
      message_body = "Hello, World!"
    }
  }
}


