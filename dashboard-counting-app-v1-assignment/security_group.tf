module "dashboard-sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.1"
  vpc_id  = module.dashboard-counting-vpc.vpc_id
  name    = var.dashboard_sg_name
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = var.ssh_access_cidr_blocks
    },
    {
      from_port   = var.dashboard_port
      to_port     = var.dashboard_port
      protocol    = "tcp"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

module "counting-sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.1"
  vpc_id  = module.dashboard-counting-vpc.vpc_id
  name    = var.counting_sg_name
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = var.ssh_access_cidr_blocks
    }
  ]
  ingress_with_source_security_group_id = [
    {
      from_port                = 22
      to_port                  = 22
      protocol                 = "tcp"
      source_security_group_id = module.dashboard-sg.security_group_id
    },
    {
      from_port                = var.counting_port
      to_port                  = var.counting_port
      protocol                 = "tcp"
      source_security_group_id = module.dashboard-sg.security_group_id
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}