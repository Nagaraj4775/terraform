resource "aws_lb_target_group" "alb_tg_test" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id
}

resource "aws_lb" "lb_test" {
  name               = "test-lb-tf"
  internal           = false
  load_balancer_type = "network"
  subnets            = [aws_subnet.public_subnet.id, aws_subnet.public_subnet_2.id]

  tags = {
    Environment = "production"
  }
}

#resource "aws_lb_listener" "front_end" {
#  load_balancer_arn = aws_lb.lb_test.arn
#  port              = "80"
#  protocol          = "HTTP"
#  default_action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.alb_tg_test.arn
#  }
#}
