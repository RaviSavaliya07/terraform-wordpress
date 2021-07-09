locals {
  vpc_cidr = "10.123.0.0/16"
}

locals {
  security_groups = {
    public = {
      name        = "public_sg"
      description = "security group for public"
      ingress = {
        ssh = {
          from        = 22
          to          = 22
          protocol    = "tcp"
          cidr_blocks = [var.access_ip]
        }
        web = {
          from        = 80
          to          = 80
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
        nfs = {
          from        = 2049
          to          = 2049
          protocol    = "tcp"
          cidr_blocks = ["0.0.0.0/0"]
        }
      }
      
    }
    rds = {
      name        = "rds_sg"
      description = "security group for rds"
      ingress = {
        rsd = {
          from        = 3306
          to          = 3306
          protocol    = "tcp"
          cidr_blocks = [local.vpc_cidr]
        }
      }
    }
    # web = {
    #   name        = "web"
    #   description = "security group for web"
    #   ingress = {
    #     web = {
    #       from        = 80
    #       to          = 80
    #       protocol    = "tcp"
    #       cidr_blocks = ["0.0.0.0/0"]
    #     }
    #   }
    # }
  }
}