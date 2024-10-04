#dns of load balancer

output "lb_dns_name" {
description = "DNS of Load balancer"
value = aws_lb.project_alb.dns_name

}

# ec2_instance public ip

output "instance_public_ip" {
description = "Public IP address of the EC2 instance"
value = aws_instance.harsha_instance.public_ip

}

output "instance_public_1_ip" {
description = "Public IP address of the EC2 instance"
value = aws_instance.harsha_instance_1.public_ip

}
#auto scaling

output "TG_ARN" {
  value = aws_lb_target_group.target-group.arn
}
