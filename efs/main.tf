module "efs" {
  source = "cloudposse/efs/aws"
  # Cloud Posse recommends pinning every module to a specific version
  # version     = "x.x.x"

  namespace       = "demo-efs"
  stage           = "test"
  name            = "app"
  region          = "ap-south-1"
  vpc_id          = var.vpc_id
  subnets         = var.subnet_id
#   security_groups = [var.security_group_id]
}