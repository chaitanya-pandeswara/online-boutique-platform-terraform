# Calling VPC Module
module "vpc" {
  source = "../modules/vpc"
  vpc_cidr = var.vpc_cidr
  env_name = var.env_name
  cidr_pub_subnet = var.cidr_pub_subnet  
}

# Calling IGW Module
module "igw" {
  source = "../modules/igw"
  vpc_id = module.vpc.vpc_id_output
  env_name = var.env_name    
}

# Calling Route Table Module
module "route-table" {
  source = "../modules/route-table"
  gateway_id = module.igw.igw_id_output  
  default_route_table_id = module.vpc.vpc_default_rtb_id_output
  subnet_ids = module.vpc.subnet_id_output
  env_name = var.env_name    
}

# Calling IAM Roles & Policies Module
module "iam-roles-policies" {
  source = "../modules/iam-roles-policies"
  env_name = var.env_name
  eks_cluster_role_name =  var.eks_cluster_role_name
  eks_node_group_role_name = var.eks_node_group_role_name   
}

# Calling Security Group Module
module "security-group" {
  source = "../modules/security-group"
  vpc_id = module.vpc.vpc_id_output  
  env_name = var.env_name    
}

# Calling EKS Module
module "eks" {
  source = "../modules/eks"
  vpc_id = module.vpc.vpc_id_output  
  env_name = var.env_name
  security_group_id = module.security-group.sg_id_output
  cluster_role_arn = module.iam-roles-policies.cluster_role_arn_output
  node_group_role_arn = module.iam-roles-policies.node_group_role_arn_output
  cluster_name = var.cluster_name
  node_group_name = var.node_group_name
  instance_types = var.instance_types
  public_access_cidrs = var.public_access_cidrs
  endpoint_private_access = var.endpoint_private_access
  endpoint_public_access = var.endpoint_public_access
  scaling_desired_size = var.scaling_desired_size
  scaling_max_size =  var.scaling_max_size
  scaling_min_size = var.scaling_min_size
  key_pair = var.key_pair
  #subnet_ids = module.vpc.subnet_id_output
  cidr_pub_subnet = module.vpc.subnet_id_output
}

