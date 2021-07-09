#---compute/main.tf

# data "aws_ami" "server_ami" {
#     most_recent = true
#     owners = ["099720109477"]

#     filter {
#         name = "name"
#         values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
#     }
# }

# resource "random_id" "demo_node_id" {
#   byte_length = 2
#   count = var.instance_count
# }

# resource "aws_network_interface" "network_if" {
#   count = var.public_sn_count
#   subnet_id   = var.public_subnets[count.index]
#   tags = {
#     Name = "primary_network_interface"
#   }
# }

# resource "aws_instance" "demo_node" {
#   count = var.instance_count
#   instance_type = var.instance_type #t3.micro
#   ami = data.aws_ami.server_ami.id
#   tags = {
#       Name = "demo-node-${random_id.demo_node_id[count.index].dec}"
#   }
#   network_interface {
#     network_interface_id = aws_network_interface.network_if.id
#     device_index         = 0
#   }
# }

# #key_name = ""
# vpc_security_group_ids = [var.public_sg]
# subnet_id = var.public_subnets[count.index]
# #user_data = ""
# root_block_device{
#     volume_size = var.vol_size #10
# }

module "ec2_cluster" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "~> 2.0"

  name                   = "demo-ec2"
  instance_count         = 1

  ami                    = "ami-00bf4ae5a7909786c"
  instance_type          = "t3.small"
  key_name               = "web-server"
  monitoring             = false
  vpc_security_group_ids = var.vpc_security_group_ids
  subnet_ids              = var.subnet_ids

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}