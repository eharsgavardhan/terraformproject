resource "aws_launch_template" "this" {
  name          = "launchtemplate"
  image_id      = var.ami
  instance_type = var.instance_type
  key_name      = "l-b"
  user_data     = file("config.sh")


  
  vpc_security_group_ids = [aws_security_group.security_project.id]
  tags = {
    Name = "auto_scaling"
  }
}
resource "aws_autoscaling_group" "this" {

  name                      = "autoscaling"
  max_size                  = var.MAX_SIZE
  min_size                  = var.MIN_SIZE
  desired_capacity          = var.DESIRED_CAP
  health_check_grace_period = 300
  health_check_type         = var.asg_health_check_type #"ELB" or default EC2
  #availability_zones = var.availability_zones #["us-east-1a"]
  vpc_zone_identifier = [var.db_1_subnet_cidr_block,var.db_1_subnet_cidr_block]
  target_group_arns   = [var.target_cloud] #var.target_group_arns

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]

  metrics_granularity = "1Minute"

  launch_template {
    id      = aws_launch_template.this.id
    version = aws_launch_template.this.latest_version #"$Latest"
  }
#   depends_on = [module.aws_lb]
}

# scale up policy
resource "aws_autoscaling_policy" "scale_up" {
  name                   = "autoscaling_policy"
  autoscaling_group_name = aws_autoscaling_group.this.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1" #increasing instance by 1 
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

# scale up alarm
resource "aws_cloudwatch_metric_alarm" "scale_up_alarm" {
  alarm_name          = "cloudwatch_metric_up"
  alarm_description   = "asg-scale-up-cpu-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "80" # New instance will be CPU utilization is higher than 80 %
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.this.name
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.scale_up.arn]
}

# scale down policy
resource "aws_autoscaling_policy" "scale_down" {
  name                   = "auto_policy"
  autoscaling_group_name = aws_autoscaling_group.this.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1" # decreasing instance by 1 
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}

# scale down alarm
resource "aws_cloudwatch_metric_alarm" "scale_down_alarm" {
  alarm_name          = "cloudwatch_metric_down"
  alarm_description   = "asg-scale-down-cpu-alarm"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "5" # Instance will scale down when CPU utilization is lower than 5 %
  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.this.name 
  }
  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.scale_down.arn]
}