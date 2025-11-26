#----------------------------------------
# time sleep to ensure cloudwatch agent is ready
#----------------------------------------           
resource "time_sleep" "tfsp_wait_time" {
  create_duration = "180s"
}

#----------------------------------------
# CloudWatch Merics Filters
#----------------------------------------
resource "aws_cloudwatch_log_metric_filter" "tfsp_be_error_metric_filter" {
  name           = "tfsp-${var.envname}-be-error-metric-filter"
  log_group_name = var.be_cloudwatch_log_group_name
  depends_on     = [time_sleep.tfsp_wait_time]

  pattern = "ERROR"

  metric_transformation {
    name      = "tfsp-${var.envname}-be-error-metric"
    namespace = "TFSP/BE/Application"
    value     = "1"
  }
}

#----------------------------------------
# CloudWatch Alarm for BE Errors    
#----------------------------------------
resource "aws_cloudwatch_metric_alarm" "tfsp_be_error_alarm" {
  alarm_name          = "tfsp-${var.envname}-be-error-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = aws_cloudwatch_log_metric_filter.tfsp_be_error_metric_filter.metric_transformation[0].name
  namespace           = aws_cloudwatch_log_metric_filter.tfsp_be_error_metric_filter.metric_transformation[0].namespace
  period              = "300"
  statistic           = "Sum"
  threshold           = 1
  alarm_description   = "This metric monitors BE application errors"
  alarm_actions = [
    var.sns_topic_arn
  ]


}
 