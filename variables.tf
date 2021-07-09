#--------variables.tf

variable "aws_region" {
  default = "ap-south-1"
}

variable "access_ip" {
  type = string
}

#------databse variable

variable "dbname" {
  type = string
}

variable "dbuser" {
  type      = string
  sensitive = true
}

variable "dbpassword" {
  type      = string
  sensitive = true
}
#----------asg variable

variable "asg_image_id" {
  type = string
}