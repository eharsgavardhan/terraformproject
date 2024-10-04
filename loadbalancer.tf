#TARGET GROUP CREATE

resource "aws_lb_target_group" "target-group" {
   name = "harshatargetgroup"
   port     = 80
  protocol = "HTTP"
   vpc_id=aws_vpc.harsha_project.id
health_check {
   path = "/health"
   port = 80
   protocol = "HTTP"
  }
}


#LOAD BALANCER CREATE

resource "aws_lb" "project_alb" {
name = "loadharsha"
internal = false
load_balancer_type = "application"
security_groups = [aws_security_group.security_project.id]
subnets = [aws_subnet.private_subnet_1.id , aws_subnet.private_subnet_2.id]
}


#ATTACH TO LB AND TG

resource "aws_lb_target_group_attachment" "attachment" {
  target_group_arn = aws_lb_target_group.target-group.arn
  target_id        = aws_instance.harsha_instance.id
  port             = 80
  depends_on = [
    aws_lb_target_group.target-group,
    aws_instance.harsha_instance,
  ]
}
resource "aws_lb_target_group_attachment" "attachment_1" {
  target_group_arn = aws_lb_target_group.target-group.arn
  target_id        = aws_instance.harsha_instance_1.id
  port             = 80
  depends_on = [
    aws_lb_target_group.target-group,
    aws_instance.harsha_instance_1,
  ]
}

resource "aws_lb_listener" "listener_elb" {
  load_balancer_arn = aws_lb.project_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group.arn
  }
}