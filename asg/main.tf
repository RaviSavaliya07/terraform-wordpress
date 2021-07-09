# #---------asg/main.tf

# # resource "random_shuffle" "az" {
# #   input        = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
# #   result_count = 3
# # }

# resource "aws_launch_template" "launch_template" {
#   name_prefix   = "demo_launch_template"
#   image_id      = var.asg_image_id
#   instance_type = var.asg_instance_type
#   placement {
#     availability_zone = "ap-south-1a"
#   }
# }

# resource "aws_autoscaling_group" "asg" {
#   name = "asg"
#   availability_zones = var.asg_availability_zone
#   desired_capacity   = var.asg_desire_capacity
#   max_size           = var.asg_max_size
#   min_size           = var.asg_min_size
#   # vpc_zone_identifier = ["${random_shuffle.az.result}"]
#   target_group_arns = [var.demo_tg_arn]
#   launch_template {
#     id      = aws_launch_template.launch_template.id
#     version = "$Latest"
#   }
#   lifecycle {
#     ignore_changes = [load_balancers, target_group_arns]
#   }
# }

# # resource "aws_autoscaling_attachment" "asg_attachment" {
# #   autoscaling_group_name = aws_autoscaling_group.asg.id
# #   # elb                    = var.loadbalancer_id
# #   alb_target_group_arn   = var.demo_tg_arn
# # }

module "asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 4.0"

  # Autoscaling group
  name = "asg"

  min_size                  = var.asg_min_size
  max_size                  = var.asg_max_size
  desired_capacity          = var.asg_desire_capacity
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
  vpc_zone_identifier       = var.public_subnet
  target_group_arns = [var.demo_tg_arn]

  # Launch template
  lt_name                = "asg-lt"
  description            = "Launch template"
  update_default_version = true

  use_lt    = true
  create_lt = true

  image_id          = var.asg_image_id
  instance_type     = var.asg_instance_type

  block_device_mappings = [
    {
      # Root volume
      device_name = "/dev/xvda"
      no_device   = 0
      ebs = {
        delete_on_termination = true
        volume_size           = 20
        volume_type           = "gp2"
      }
      }
  ]


  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 32
  }

  network_interfaces = [
    {
      delete_on_termination = true
      description           = "eth0"
      device_index          = 0
      security_groups       = ["var.web_sg"]
    }
  ]

  placement = {
    availability_zone = "var.asg_availability_zone"
  }

  tag_specifications = [
    {
      resource_type = "instance"
      tags          = { WhatAmI = "Instance" }
    },
    {
      resource_type = "volume"
      tags          = { WhatAmI = "Volume" }
    },
    {
      resource_type = "spot-instances-request"
      tags          = { WhatAmI = "SpotInstanceRequest" }
    }
  ]

  tags = [
    {
      key                 = "Environment"
      value               = "dev"
      propagate_at_launch = true
    },
    {
      key                 = "Project"
      value               = "megasecret"
      propagate_at_launch = true
    },
  ]

 
}