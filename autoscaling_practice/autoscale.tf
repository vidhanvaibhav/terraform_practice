resource "aws_launch_template" "webapp_launchtemp" {
  name          = "webapp_launchtemp"
  instance_type = var.instance
  #subnets = [aws_subnet.webapp_pubsub1.id, aws_subnet.webapp_pubsub2.id]
  image_id               = var.ami_id
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  user_data              = filebase64("/home/ec2-user/autoscaling/install_apache.sh")
  key_name               = "vidhan"
  #associate_public_ip_address="true" 
}

resource "aws_autoscaling_group" "webapp_scalegp" {
  name                = "webapp_scalegp"
  desired_capacity    = var.scalegp_dc
  max_size            = var.scalegp_maxsize
  min_size            = var.scalegp_minsize
  vpc_zone_identifier = [aws_subnet.webapp_pubsub1.id, aws_subnet.webapp_pubsub2.id]
  launch_template {
    id = aws_launch_template.webapp_launchtemp.id
    version="$Latest"
  }
  target_group_arns = [aws_lb_target_group.webapp_tg.arn]

}
resource "aws_cloudwatch_metric_alarm" "scale_up" {
  alarm_description   = "Monitors CPU utilization"
  alarm_name          = "test_scale_up"
  comparison_operator = "GreaterThanThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = 60                   # Integer value
  evaluation_periods  = 1                    # Integer value
  period              = 120                   # Integer value
  statistic           = "Average"


   dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.webapp_scalegp.name
  }

  alarm_actions = [aws_autoscaling_policy.scale_out.arn]
}


resource "aws_autoscaling_policy" "scale_out" {
  name                   = "scale-out"
  scaling_adjustment     = 1 # Increase the number of instances by 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 120 # Optional: Wait 300 seconds before another scaling activity
  autoscaling_group_name = aws_autoscaling_group.webapp_scalegp.name
}

resource "aws_cloudwatch_metric_alarm" "scale_in" {
  alarm_description   = "Monitors CPU utilization"
  alarm_name          = "test_scale_in"
  comparison_operator = "LessThanThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = 30                   # Integer value
  evaluation_periods  = 1                    # Integer value
  period              = 120                   # Integer value
  statistic           = "Average"


   dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.webapp_scalegp.name
  }

  alarm_actions = [aws_autoscaling_policy.scale_in.arn]

}

resource "aws_autoscaling_policy" "scale_in" {
  name                   = "scale-in"
  scaling_adjustment     = 1  # Increase the number of instances by 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300  # Optional: Wait 300 seconds before another scaling activity
  autoscaling_group_name = aws_autoscaling_group.webapp_scalegp.name
}


