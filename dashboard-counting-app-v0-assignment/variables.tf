# -------------------------
# Provider Configuration
# -------------------------

variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "ap-southeast-1"
}

variable "aws_profile" {
  description = "The AWS profile to use"
  type        = string
  default     = "master-console-admin-IAMuser"
}

# -------------------------
# VPC
# -------------------------

variable "cidr_block_for_VPC" {
  description = "The CIDR block for the Dashboard Counting App VPC"
  type        = string
  default     = "172.16.0.0/16"
}

variable "enable_dns_support" {
  description = "Whether to enable DNS support for the VPC"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Whether to enable DNS hostnames for the VPC"
  type        = bool
  default     = true
}

# -------------------------
# Subnet
# -------------------------

variable "cidr_block_for_Public_Subnet" {
  description = "The CIDR block for the public subnet"
  type        = string
  default     = "172.16.1.0/24"
}

variable "availability_zone_for_Public_Subnet" {
  description = "The availability zone for the public subnet"
  type        = string
  default     = "ap-southeast-1a"
}

variable "cidr_block_for_Private_Subnet" {
  description = "The CIDR block for the private subnet"
  type        = string
  default     = "172.16.2.0/24"
}

variable "availability_zone_for_Private_Subnet" {
  description = "The availability zone for the private subnet"
  type        = string
  default     = "ap-southeast-1b"
}

variable "map_public_ip_on_launch_for_Public_Subnet" {
  description = "Whether to map public IP on launch for the public subnet"
  type        = bool
  default     = true
}

variable "map_public_ip_on_launch_for_Private_Subnet" {
  description = "Whether to map public IP on launch for the private subnet"
  type        = bool
  default     = false
}

# -------------------------
# Route for Internet Gateway && Nat Gateway
# -------------------------

variable "destination_cidr_block_for_igw_route" {
  description = "The destination CIDR block for the Internet Gateway route"
  type        = string
  default     = "0.0.0.0/0"
}

variable "destination_cidr_block_for_natgw_route" {
  description = "The destination CIDR block for the NAT Gateway route"
  type        = string
  default     = "0.0.0.0/0"
}

# -------------------------
# Security Group for Dashboard
# -------------------------

variable "name_for_sg_dashboard" {
  description = "The name for the security group for the dashboard"
  type        = string
  default     = "Security_Group_for_Dashboard"
}

variable "description_for_sg_dashboard" {
  description = "The description for the security group for the dashboard"
  type        = string
  default     = "Security group for the dashboard allowing inbound traffic on port 22,80,443 and all outbound traffic"
}

variable "cidr_block_for_local_network" {
  description = "Optional CIDR block for your local network. Leave null to auto-detect your current public IP and use /32."
  type        = string
  default     = null
  nullable    = true
}

variable "anywhere" {
  description = "The CIDR block for anywhere"
  type        = string
  default     = "0.0.0.0/0"
}

# -------------------------
# Security Group for Counting
# -------------------------

variable "name_for_sg_counting" {
  description = "The name for the security group for counting"
  type        = string
  default     = "Security_Group_for_Counting"
}

variable "description_for_sg_counting" {
  description = "The description for the security group for counting"
  type        = string
  default     = "Security group for the counting service allowing inbound traffic from the dashboard and all outbound traffic"
}

# -------------------------
# Key Pair for Dashboard and Counting Instances
# -------------------------

variable "filepath" {
  description = "file path for the private key for the dashboard and counting instances"
  type        = string
  default     = "~/.ssh/dashboard_counting_key_pair.pem"
}

# -------------------------
# EC2 Instance for Dashboard
# -------------------------

variable "ami_id_for_Dashboard_Counting_Instance" {
  description = "The AMI ID for the dashboard EC2 instance"
  type        = string
  default     = "ami-0be9cb9f67c8dabd6"
}

variable "instance_type_for_Dashboard_Counting_Instance" {
  description = "The instance type for the dashboard EC2 instance"
  type        = string
  default     = "t3.micro"
}

variable "Dashboard_Instance_private_ip" {
  description = "The private IP address for the dashboard EC2 instance"
  type        = string
  default     = "172.16.1.10"
}

variable "Counting_Instance_private_ip" {
  description = "The private IP address for the counting EC2 instance"
  type        = string
  default     = "172.16.2.10"
}

variable "dashboard_service_port" {
  description = "The port on which the dashboard service will run"
  type        = string
  default     = "9002"
}

variable "counting_service_port" {
  description = "The port on which the counting service will run"
  type        = string
  default     = "9003"

}
