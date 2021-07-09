#------/networking/output

output "vpc_id" {
  value = aws_vpc.demo_vpc.id
}

output "db_security_group" {
  value = [aws_security_group.demo_sg["rds"].id]
}

output "public_sg" {
  value = [aws_security_group.demo_sg["public"].id]
}

# output "web_sg" {
#   value = [aws_security_group.demo_sg["web"].id]
# }

output "db_subnet_group_name" {
  value = aws_db_subnet_group.demo_rds_subnetgroup.*.name
}

output "public_subnets" {
  value = aws_subnet.demo_public_subnet.*.id
}

output "private_subnet" {
  value = aws_subnet.demo_private_subnet.*.id
}