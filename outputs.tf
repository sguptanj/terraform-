###################################
## Output: listener rules
###################################
# output "listener_rule_pattern_arn" {
#   value = module.listener_rule.*.listener_rule_pattern_arn
# }


##########################################
## launch template
##########################################
output "lt_id" {
  value = module.web_asg_lt.launch_template_id
}
##########################################
## auto scaling group
##########################################
output "asg_name" {
  value = module.web_asg_lt.aws_autoscaling_id
}



