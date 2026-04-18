module "dashboard-instance" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "6.4.0"
  name                        = var.dashboard_app_ec2_instance_name
  instance_type               = var.instance_type
  ami                         = var.ami
  associate_public_ip_address = var.associate_public_ip_address
  key_name                    = var.key_name
  subnet_id                   = module.dashboard-counting-vpc.public_subnets[0]
  private_ip                  = var.dashboard_private_ip
  vpc_security_group_ids      = [module.dashboard-sg.security_group_id]
  tags = {
    Name = var.dashboard_service_name
  }
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
    Environment="PORT=${var.dashboard_port}"
    Environment="COUNTING_SERVICE_URL=http://${module.counting-instance.private_ip}:${var.counting_port}"
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
    echo "${file(var.private_key_path)}" \
      > /home/ubuntu/.ssh/dashboard_counting_key_pair.pem
    chmod 600 /home/ubuntu/.ssh/dashboard_counting_key_pair.pem
    chown ubuntu:ubuntu /home/ubuntu/.ssh/dashboard_counting_key_pair.pem
  EOF
}

module "counting-instance" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "6.4.0"
  name                   = var.counting_app_ec2_instance_name
  instance_type          = var.instance_type
  ami                    = var.ami
  key_name               = var.key_name
  subnet_id              = module.dashboard-counting-vpc.private_subnets[0]
  private_ip             = var.counting_private_ip
  vpc_security_group_ids = [module.counting-sg.security_group_id]
  tags = {
    Name = var.counting_service_name
  }
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
    Environment="PORT=${var.counting_port}"
    ExecStart=/usr/local/bin/counting-service
    Restart=always
    RestartSec=5

    [Install]
    WantedBy=multi-user.target
    SERVICE

    systemctl daemon-reload
    systemctl enable --now counting
  EOF
}