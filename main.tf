# -------------------------
# VPC
# -------------------------

resource "aws_vpc" "Dashboard_Counting_App_VPC" {
  cidr_block           = var.cidr_block_for_VPC
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  tags = {
    Name = "Dashboard Counting App VPC"
  }
}

# -------------------------
# Subnet
# -------------------------

resource "aws_subnet" "Public_Subnet_for_Dashboard" {
  vpc_id                  = aws_vpc.Dashboard_Counting_App_VPC.id
  cidr_block              = var.cidr_block_for_Public_Subnet
  availability_zone       = var.availability_zone_for_Public_Subnet
  map_public_ip_on_launch = var.map_public_ip_on_launch_for_Public_Subnet
  tags = {
    Name = "Public Subnet for Dashboard"
  }
}

resource "aws_subnet" "Private_Subnet_for_Counting" {
  vpc_id                  = aws_vpc.Dashboard_Counting_App_VPC.id
  cidr_block              = var.cidr_block_for_Private_Subnet
  availability_zone       = var.availability_zone_for_Private_Subnet
  map_public_ip_on_launch = var.map_public_ip_on_launch_for_Private_Subnet
  tags = {
    Name = "Private Subnet for Counting"
  }
}

# -------------------------
# Internet Gateway
# -------------------------

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.Dashboard_Counting_App_VPC.id

  tags = {
    Name = "Dashboard Counting App Internet Gateway"
  }
}

# -------------------------
# Route Table
# -------------------------

resource "aws_route_table" "Public_Route_Table_for_Dashboard" {
  vpc_id = aws_vpc.Dashboard_Counting_App_VPC.id

  tags = {
  Name = "Public Route Table for Dashboard" }
}

resource "aws_route_table" "Private_Route_Table_for_Counting" {
  vpc_id = aws_vpc.Dashboard_Counting_App_VPC.id

  tags = {
    Name = "Private Route Table for Counting"
  }
}

# -------------------------
# Route Table Association
# -------------------------

resource "aws_route_table_association" "Public_Subnet_Association_with_Subnet" {
  subnet_id      = aws_subnet.Public_Subnet_for_Dashboard.id
  route_table_id = aws_route_table.Public_Route_Table_for_Dashboard.id
}

resource "aws_route_table_association" "Private_Subnet_Association_with_Subnet" {
  subnet_id      = aws_subnet.Private_Subnet_for_Counting.id
  route_table_id = aws_route_table.Private_Route_Table_for_Counting.id
}

# -------------------------
# Route for Internet Gateway
# -------------------------

resource "aws_route" "igw_route_for_Public_Route_Table_for_Dashboard" {
  route_table_id         = aws_route_table.Public_Route_Table_for_Dashboard.id
  destination_cidr_block = var.destination_cidr_block_for_igw_route
  gateway_id             = aws_internet_gateway.igw.id
}

# -------------------------
# NAT Gateway
# -------------------------

resource "aws_eip" "eip_for_NAT_Gateway" {
  domain = "vpc"
  tags = {
    Name = "EIP for NAT Gateway"
  }
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.eip_for_NAT_Gateway.id
  subnet_id     = aws_subnet.Public_Subnet_for_Dashboard.id

  tags = {
    Name = "NAT Gateway"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route" "ngw_route_for_Private_Route_Table_for_Counting" {
  route_table_id         = aws_route_table.Private_Route_Table_for_Counting.id
  destination_cidr_block = var.destination_cidr_block_for_natgw_route
  nat_gateway_id         = aws_nat_gateway.ngw.id
}

# -------------------------
# Security Group for Dashboard
# -------------------------

resource "aws_security_group" "Security_Group_for_Dashboard" {
  name        = var.name_for_sg_dashboard
  description = var.description_for_sg_dashboard
  vpc_id      = aws_vpc.Dashboard_Counting_App_VPC.id

  ingress {
    description = "SSH from local network"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = local.local_network_cidr_block
  }

  ingress {
    description = "Dashboard HTTP from anywhere"
    from_port   = 9002
    to_port     = 9002
    protocol    = "tcp"
    cidr_blocks = [var.anywhere]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.anywhere]
  }

  tags = {
    Name = "Security_Group_for_Dashboard"
  }
}

# -------------------------
# Security Group for Counting
# -------------------------

resource "aws_security_group" "Security_Group_for_Counting" {
  name        = var.name_for_sg_counting
  description = var.description_for_sg_counting
  vpc_id      = aws_vpc.Dashboard_Counting_App_VPC.id

  ingress {
    description     = "Allow ssh from dashboard instance"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.Security_Group_for_Dashboard.id]
  }

  ingress {
    description = "SSH from local network"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = local.local_network_cidr_block
  }

  ingress {
    description     = "Counting service HTTP from dashboard instance"
    from_port       = 9003
    to_port         = 9003
    protocol        = "tcp"
    security_groups = [aws_security_group.Security_Group_for_Dashboard.id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.anywhere]
  }

  tags = {
    Name = "Security_Group_for_Counting"
  }
}

# -------------------------
# Key Pair for EC2 Instances
# -------------------------
resource "tls_private_key" "dashboard_counting_key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Register Public Key with AWS
resource "aws_key_pair" "dashboard_counting_key_pair" {
  key_name   = "dashboard_counting_key_pair"
  public_key = tls_private_key.dashboard_counting_key_pair.public_key_openssh

  tags = {
    Name = "dashboard_counting_key_pair"
  }
}

# Save Private Key to your laptop
resource "local_file" "ssh_private_key" {
  filename        = pathexpand(var.filepath)
  content         = tls_private_key.dashboard_counting_key_pair.private_key_pem
  file_permission = "0600"
}

# -------------------------
# EC2 Instance for Dashboard and Counting
# -------------------------

resource "aws_instance" "Dashboard_Instance" {
  ami                         = var.ami_id_for_Dashboard_Counting_Instance
  instance_type               = var.instance_type_for_Dashboard_Counting_Instance
  subnet_id                   = aws_subnet.Public_Subnet_for_Dashboard.id
  vpc_security_group_ids      = [aws_security_group.Security_Group_for_Dashboard.id]
  key_name                    = aws_key_pair.dashboard_counting_key_pair.key_name
  associate_public_ip_address = true
  private_ip                  = var.Dashboard_Instance_private_ip
  depends_on                  = [aws_instance.Counting_Instance]

  user_data = <<-EOF
    #!/bin/bash
    set -e

    # Ubuntu uses apt
    apt-get update -y
    apt-get install -y unzip curl

    # Download Dashboard binary
    curl -L https://github.com/hashicorp/demo-consul-101/releases/download/v0.0.5/dashboard-service_linux_amd64.zip \
      -o /tmp/dashboard.zip
    cd /tmp && unzip -o dashboard.zip
    mv /tmp/dashboard-service_linux_amd64 /usr/local/bin/dashboard-service
    chmod +x /usr/local/bin/dashboard-service

    # Create systemd service
    cat <<'SERVICE' > /etc/systemd/system/dashboard.service
    [Unit]
    Description=Dashboard Service
    After=network.target

    [Service]
    Environment="PORT=${var.dashboard_service_port}"
    Environment="COUNTING_SERVICE_URL=http://${aws_instance.Counting_Instance.private_ip}:${var.counting_service_port}"
    ExecStart=/usr/local/bin/dashboard-service
    Restart=always
    RestartSec=5

    [Install]
    WantedBy=multi-user.target
    SERVICE

    systemctl daemon-reload
    systemctl enable --now dashboard

    # Copy private key so Dashboard EC2 can SSH into Counting EC2
    mkdir -p /home/ubuntu/.ssh
    echo "${tls_private_key.dashboard_counting_key_pair.private_key_pem}" \
      > /home/ubuntu/.ssh/dashboard_counting_key_pair.pem
    chmod 600 /home/ubuntu/.ssh/dashboard_counting_key_pair.pem
    chown ubuntu:ubuntu /home/ubuntu/.ssh/dashboard_counting_key_pair.pem
  EOF

  tags = {
    Name = "Dashboard Service"
  }
}

resource "aws_instance" "Counting_Instance" {
  ami                         = var.ami_id_for_Dashboard_Counting_Instance
  instance_type               = var.instance_type_for_Dashboard_Counting_Instance
  subnet_id                   = aws_subnet.Private_Subnet_for_Counting.id
  vpc_security_group_ids      = [aws_security_group.Security_Group_for_Counting.id]
  key_name                    = aws_key_pair.dashboard_counting_key_pair.key_name
  private_ip                  = var.Counting_Instance_private_ip
  associate_public_ip_address = false

  user_data = <<-EOF
    #!/bin/bash
    set -e

    apt-get update -y
    apt-get install -y curl unzip

    # Download Counting binary
    curl -L https://github.com/hashicorp/demo-consul-101/releases/download/v0.0.5/counting-service_linux_amd64.zip \
      -o /tmp/counting.zip
    cd /tmp && unzip -o counting.zip
    mv /tmp/counting-service_linux_amd64 /usr/local/bin/counting-service
    chmod +x /usr/local/bin/counting-service

    # Create systemd service
    cat <<'SERVICE' > /etc/systemd/system/counting.service
    [Unit]
    Description=Counting Service
    After=network.target

    [Service]
    Environment="PORT=${var.counting_service_port}"
    ExecStart=/usr/local/bin/counting-service
    Restart=always
    RestartSec=5

    [Install]
    WantedBy=multi-user.target
    SERVICE

    systemctl daemon-reload
    systemctl enable --now counting
  EOF

  tags = {
    Name = "Counting Service"
  }
}
