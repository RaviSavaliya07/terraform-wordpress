#--------database/main.tf

# resource "aws_db_instance" "demo_db" {
#   allocated_storage               = var.db_storage
#   engine                          = "mysql"
#   engine_version                  = var.db_engine_version
#   instance_class                  = var.db_instance_class
#   max_allocated_storage           = 100
#   storage_encrypted               = false
#   name                            = var.dbname
#   username                        = var.dbuser
#   password                        = var.dbpassword
#   db_subnet_group_name            = var.db_subnet_group_name
#   multi_az                        = true
#   vpc_security_group_ids          = var.vpc_security_group_ids
#   identifier                      = var.db_identifier
#   skip_final_snapshot             = var.skip_final_snapshot
#   maintenance_window              = "Mon:00:00-Mon:03:00"
#   backup_window                   = "03:00-06:00"
#   enabled_cloudwatch_logs_exports = ["general"]
#   backup_retention_period         = 1
#   deletion_protection             = false
#   tags = {
#     Name = "demo-db"
#   }
# }



module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 3.0"

  identifier = "demodb"

  engine            = "mysql"
  engine_version    = var.db_engine_version
  instance_class    = var.db_instance_class
  allocated_storage = 20

  name     = var.dbname
  username = var.dbuser
  password = var.dbpassword
  port     = "3306"

  # iam_database_authentication_enabled = true

  vpc_security_group_ids = var.vpc_security_group_ids

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"
  backup_retention_period = 5
  multi_az                        = true
  skip_final_snapshot             = var.skip_final_snapshot
  enabled_cloudwatch_logs_exports = ["general"]
  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  # monitoring_interval = "30"
  # monitoring_role_name = "MyRDSMonitoringRole"
  # create_monitoring_role = true

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  # DB subnet group
  subnet_ids = var.db_subnet_id

  # DB parameter group
  family = "mysql8.0"

  # DB option group
  major_engine_version = "8.0"

  # Database Deletion Protection
  deletion_protection = false

  parameters = [
    {
      name = "character_set_client"
      value = "utf8mb4"
    },
    {
      name = "character_set_server"
      value = "utf8mb4"
    }
  ]
  
}

module "replica" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "replica-db"

  # Source database. For cross-region use db_instance_arn
  replicate_source_db = module.db.db_instance_id

  engine               = "mysql"
  engine_version       = var.db_engine_version
  family               = "mysql8.0"
  major_engine_version = "8.0"
  instance_class       =  var.db_instance_class

  allocated_storage     = 20
  max_allocated_storage = 100
  storage_encrypted     = false
   subnet_ids = var.db_subnet_id

  # Username and password should not be set for replicas
  username = null
  password = null
  port     = "3306"

  multi_az               = false
  vpc_security_group_ids = var.vpc_security_group_ids

  maintenance_window              = "Tue:00:00-Tue:03:00"
  backup_window                   = "03:00-06:00"
  enabled_cloudwatch_logs_exports = ["general"]

  backup_retention_period = 0
  skip_final_snapshot     = true
  deletion_protection     = false

  # Not allowed to specify a subnet group for replicas in the same region
  create_db_subnet_group = false
}