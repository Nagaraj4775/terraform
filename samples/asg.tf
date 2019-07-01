

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"
  vpc_id = aws_vpc.main.id
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_configuration" "as_conf" {
  name_prefix   = "terraform-lc-example-"
  image_id      = "ami-0b898040803850657"
  instance_type = "t2.micro"
  key_name = "Nagaraj_AWS"
  #security_groups = [aws_security_group.instance.id]
  security_groups = [aws_security_group.common_SG.id, aws_security_group.instance.id]
  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "terraform" {
  name                 = "terraform-asg-example"
  launch_configuration = aws_launch_configuration.as_conf.name
  min_size             = 2
  max_size             = 2
  availability_zones = ["us-east-1a", "us-east-1b"]
  vpc_zone_identifier = [aws_subnet.public_subnet.id, aws_subnet.public_subnet_2.id]      
  target_group_arns = [aws_lb_target_group.alb_tg_test.arn]

  lifecycle {
    create_before_destroy = true
  }
}
