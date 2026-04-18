key_name         = "dashboard_counting_key_pair"
public_key_path  = "/home/salai/.ssh/dashboard.pub"
private_key_path = "/home/salai/.ssh/dashboard"

####################################################################################################
# Variables for the VPC module
####################################################################################################

vpc_name           = "dashboard_counting_vpc"
cidr               = "192.168.0.0/16"
region             = "ap-southeast-1"
azs                = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
public_subnets     = ["192.168.1.0/24"]
private_subnets    = ["192.168.2.0/24"]
enable_nat_gateway = true
single_nat_gateway = true
tags = {
  "region"      = "Singapore",
  "Environment" = "Dashboard-Counting-App",
}
public_subnet_tags = {
  "Type" = "Public_subnet"
}
private_subnet_tags = {
  "Type" = "Private_subnet"
}
create_igw                       = true
create_private_nat_gateway_route = true

####################################################################################################
# Variables for ec2-instance module
####################################################################################################

dashboard_app_ec2_instance_name = "dashboard-app-ec2-instance"
instance_type                   = "t3.micro"
ami                             = "ami-0e7ff22101b84bcff"
associate_public_ip_address     = true
dashboard_private_ip            = "192.168.1.10"
counting_app_ec2_instance_name  = "counting-app-ec2-instance"
counting_private_ip             = "192.168.2.10"
dashboard_service_name          = "Dashboard Service"
counting_service_name           = "Counting Service"

####################################################################################################
# Security group
####################################################################################################

dashboard_sg_name      = "dashboard-sg"
ssh_access_cidr_blocks = "116.89.17.84/32"
dashboard_port         = 9002
counting_sg_name       = "counting-sg"
counting_port          = 9003