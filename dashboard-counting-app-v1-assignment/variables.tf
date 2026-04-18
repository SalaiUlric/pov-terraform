variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
  default     = ""
}

variable "public_key_path" {
  description = "Path to the public SSH key"
  type        = string
  default     = ""
}

variable "private_key_path" {
  description = "Path to the private SSH key"
  type        = string
  default     = ""
}

####################################################################################################
# Variables for the VPC module
####################################################################################################

variable "vpc_name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = ""
}

variable "cidr" {
  description = "(Optional) The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using `ipv4_netmask_length` & `ipv4_ipam_pool_id`"
  type        = string
  default     = "10.0.0.0/16"
}

variable "region" {
  description = "Region where the resource(s) will be managed. Defaults to the region set in the provider configuration"
  type        = string
  default     = null
}

variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default     = []
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "enable_nat_gateway" {
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  type        = bool
  default     = false
}

variable "single_nat_gateway" {
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "public_subnet_tags" {
  description = "Additional tags for the public subnets"
  type        = map(string)
  default     = {}
}

variable "private_subnet_tags" {
  description = "Additional tags for the private subnets"
  type        = map(string)
  default     = {}
}

variable "create_igw" {
  description = "Controls if an Internet Gateway is created for public subnets and the related routes that connect them"
  type        = bool
  default     = true
}

variable "create_private_nat_gateway_route" {
  description = "Controls if a nat gateway route should be created to give internet access to the private subnets"
  type        = bool
  default     = true
}

####################################################################################################
# Variables for ec2-instance module
####################################################################################################

variable "dashboard_app_ec2_instance_name" {
  description = "Name to be used on EC2 instance created"
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "The type of instance to start"
  type        = string
  default     = "t3.micro"
}

variable "ami" {
  description = "ID of AMI to use for the instance"
  type        = string
  default     = null
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with an instance in a VPC"
  type        = bool
  default     = false
}

variable "dashboard_private_ip" {
  description = "The private IP address to assign to the instance"
  type        = string
  default     = null
}

variable "counting_app_ec2_instance_name" {
  description = "Name to be used on EC2 instance created"
  type        = string
  default     = ""
}

variable "counting_private_ip" {
  description = "The private IP address to assign to the instance"
  type        = string
  default     = null
}

variable "dashboard_service_name" {
  description = "Name of the dashboard service"
  type        = string
  default     = null
}

variable "counting_service_name" {
  description = "Name of the counting service"
  type        = string
  default     = null
}

####################################################################################################
# Security Group
####################################################################################################

variable "dashboard_sg_name" {
  description = "Name of security group - not required if create_sg is false"
  type        = string
  default     = null
}

variable "ssh_access_cidr_blocks" {
  description = "List of CIDR blocks that are allowed to access the EC2 instance via SSH (port 22)"
  type        = string
  default     = null
}

variable "dashboard_port" {
  description = "The port number for the dashboard application"
  type        = number
  default     = null
}

variable "counting_sg_name" {
  description = "Name of security group - not required if create_sg is false"
  type        = string
  default     = null
}

variable "counting_port" {
  description = "The port number for the counting application"
  type        = number
  default     = null
}

####################################################################################################
# User data for EC2 instances
####################################################################################################

variable "dashboard_user_data" {
  description = "User data for the dashboard EC2 instance"
  type        = string
  default     = ""
}

variable "counting_user_data" {
  description = "User data for the counting EC2 instance"
  type        = string
  default     = ""
}