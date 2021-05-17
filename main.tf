module "web_listener_rule" {
  #source       = "git@gitlab.dainternal.com:devops/infrastructure/monolith/terraform/modules/listener_rules.git"
  source        ="git@gitlab.com:ot-client/docasap/tf-modules/listener_rules.git"
  listener_arn = data.terraform_remote_state.base_infra.outputs.web_https_listener_rules
  listener_rules_details = [{
    priority         = 89
    path_pattern     = var.path_pattern
    host_header      = []
    http_header      = []
    query_string     = []
    target_group_arn = module.web_target_group.target_group_arn
    },
    {
      priority         = 70
      path_pattern     = []
      host_header      = []
      query_string     = []
      http_header      = var.http_header
      target_group_arn = module.web_target_group.target_group_arn
    },
    {
      priority         = 100
      path_pattern     = []
      query_string     = var.query_string
      host_header      = []
      http_header      = []
      target_group_arn = module.web_target_group.target_group_arn
    },
    {
      priority         = 105
      path_pattern     = []
      query_string     = var.query_string
      host_header      = var.host_header
      http_header      = var.http_header
      target_group_arn = module.web_target_group.target_group_arn
    }
  ]
}

module "web_target_group" {
  #source               = "git@gitlab.dainternal.com:devops/infrastructure/monolith/terraform/modules/target_group
  #.git?ref=develop"
  source = "git@gitlab.com:ot-client/docasap/tf-modules/target_group.git?ref=master"
  target_group_details = var.target_group_details
  vpc_id               = var.vpc_id
  healthy_threshold    = var.healthy_threshold
  unhealthy_threshold  = var.unhealthy_threshold
  timeout              = var.timeout
  interval             = var.interval
  health_check_path    = var.health_check_path
  health_check_port    = var.health_check_port
  deregistration_delay = var.deregistration_delay
  slow_start           = var.slow_start
  # port                 = 80
}

module "web_asg_lt" {
  # details for launch template
  #source                 = "git@gitlab.dainternal.com:devops/infrastructure/monolith/terraform/modules/asg_lt.git?ref=develop"
  source = "git@gitlab.com:ot-client/docasap/tf-modules/asg_lt.git"
  lt_name                = var.launch_template_name
  ami_id                 = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = var.vpc_security_group_ids
  lt_tags                = var.additional_tags
  iam_instance_profile = [{
    arn = var.iam_instance_profile_arn
  }]
  lt_description = var.lt_description
  user_data      = filebase64("userdata.sh")

  # details for auto scaling group
  asg_name         = var.asg_name
  max_size         = var.max_size
  min_size         = var.min_size
  desired_capacity = var.desired_capacity
  subnet_ids       = var.pvt_subnet_ids
  asg_tags         = var.additional_tags_asg
  target_group_arn = module.web_target_group.target_group_arn
}
