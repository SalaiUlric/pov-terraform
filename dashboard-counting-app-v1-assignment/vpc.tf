module "dashboard-counting-vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.1"

  name                             = var.vpc_name
  cidr                             = var.cidr
  azs                              = var.azs
  public_subnets                   = var.public_subnets
  private_subnets                  = var.private_subnets
  enable_nat_gateway               = var.enable_nat_gateway
  single_nat_gateway               = var.single_nat_gateway
  tags                             = var.tags
  public_subnet_tags               = var.public_subnet_tags
  private_subnet_tags              = var.private_subnet_tags
  create_igw                       = var.create_igw
  create_private_nat_gateway_route = var.create_private_nat_gateway_route
}