#---------root/main.tf

module "networking" {
  source           = "./networking"
  vpc_cidr         = local.vpc_cidr
  access_ip        = var.access_ip
  security_groups  = local.security_groups
  public_sn_count  = 2
  private_sn_count = 2
  max_subnets      = 20
  public_cidrs     = [for i in range(2, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  private_cidrs    = [for i in range(1, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  db_subnet_group  = true
}

module "database"{
  source = "./database"
  db_storage = 10
  db_engine_version = "8.0.20"
  db_instance_class = "db.t3.large"
  dbname = var.dbname
  dbuser = var.dbuser
  dbpassword = var.dbpassword
  db_identifier = "demo-db"
  skip_final_snapshot = true
  db_subnet_id = module.networking.private_subnet
  # db_subnet_group_name = module.networking.db_subnet_group_name[0]
  vpc_security_group_ids = module.networking.db_security_group
}

module "loadbalancing" {
  source                 = "./loadbalancing"
  security_groups              = module.networking.public_sg
  subnet_ids         = module.networking.public_subnets
  vpc_id                 = module.networking.vpc_id
}

module "compute" {
  source = "./compute"
  vpc_security_group_ids = module.networking.public_sg
  subnet_ids = module.networking.public_subnets
  
}

module "efs" {
  source = "./efs"
  vpc_id = module.networking.vpc_id
  subnet_id = module.networking.public_subnets
}

# module "asg"{
#   depends_on = [
#     module.loadbalancing
#   ]
#   source = "./asg"
#   asg_image_id = var.asg_image_id
#   asg_availability_zone = ["ap-south-1a"]
#   asg_instance_type = "t2.micro"
#   asg_desire_capacity = 1
#   asg_max_size = 1
#   asg_min_size = 1
#   # loadbalancer_id = module.loadbalancing.loadbalancer_id
#   demo_tg_arn = module.loadbalancing.demo_tg_arn
#   web_sg = module.networking.web_sg
#   public_subnet = module.networking.public_subnets
# }