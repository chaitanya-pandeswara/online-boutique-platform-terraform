

## **Design Document: AWS EKS Platform Deployment with Terraform**

**1. Overview**

**1.1 Project Summary**

This project aims to deploy a scalable and secure platform on AWS using Terraform. The platform includes the following components: VPC, Subnet, IGW, Route Tables, Security Groups, IAM roles, and EKS.

**1.2 Objectives**

- Provision AWS infrastructure using Infrastructure as Code (IaC) principles with Terraform.

- Create a VPC with defined subnets, IGW, and route tables.

- Implement Security Groups for controlling inbound and outbound traffic.

- Set up IAM roles for necessary permissions.

- Deploy and manage an EKS cluster for container orchestration.

  

**2. Architecture**

**2.1 Infrastructure Overview**

​     **GitHub Folder Structure**

​     **<img width="302" alt="github-folder-structure" src="https://github.com/chaitanya-pandeswara/online-boutique-platform-terraform/assets/57262203/9b040d1a-9b15-4577-a899-f82774e90dbc">**



**GitHub Link**

https://github.com/chaitanya-pandeswara/online-boutique-platform-terraform/tree/dev



**Architectural Diagram**

<img width="544" alt="project-architectural-diagram" src="https://github.com/chaitanya-pandeswara/online-boutique-platform-terraform/assets/57262203/3f5ccc16-e6ba-47ca-bab8-9261c1888490">





**2.2 Components**

**2.2.1 VPC**

- **Purpose:** Provide network isolation for the platform.
- **Configuration:**
  - CIDR Block: **10.0.0.0/16**
  - Subnets: **10.0.101.0/24**, **10.0.102.0/24**
  - Name: **terra-vpc**

**2.2.2 Subnets**

- **Purpose:** Divide the VPC into isolated segments for resources.
- **Configuration:**
  - Subnet 1:
    - CIDR Block: **10.0.101.0/24**
    - Availability Zone: **ap-south-1a**
    - Name: **terra-pub1**
  - Subnet 2:
    - CIDR Block: **10.0.102.0/24**
    - Availability Zone: **ap-south-1b**
    - Name: **terra-pub2**

**2.2.3 Internet Gateway (IGW)**

- **Purpose:** Enable internet access for resources in the VPC.
- **Configuration:**
  - Attached to the VPC **terra-vpc**.
  - Name: **terra-igw**

**2.2.4 Route Tables**

- **Purpose:** Define routing rules for the VPC.
- **Configuration:**
  - Main/Default Route Table:
    - Name: **terra-rtb**
    - Routes: **0.0.0.0/0** via IGW.
    - Routes: **10.0.0.0/16** via local.
    - Subnets Association: **10.0.101.0/24**, **10.0.102.0/24**
  - Subnet Route Tables: (as applicable)

**2.2.5 Security Groups**

- **Purpose:** Control inbound and outbound traffic for EC2 instances.
- **Configuration:**
  - Name: **terra-sg**
  - Ingress Rules: Allow specified ports and sources.
  - Egress Rules: Allow necessary outbound traffic.

**2.2.6 IAM Roles**

- **Purpose:** Define roles for EC2 instances and EKS cluster.
- **Configuration:**
  - Role 1: 
    - Name: **eksClusterRole**
    - Permissions: **AmazonEKSClusterPolicy**
    - Permissions: **AmazonEKSVPCResourceController**
  - Role 2: 
    - Name: **eksNodeGroupRole**
    - Permissions: **AmazonEKSWorkerNodePolicy**
    - Permissions: **AmazonEKS_CNI_Policy**
    - Permissions: **AmazonEC2ContainerRegistryReadOnly**
  - Role 3: 
    - Name: **jenkinsRole**
    - Permissions: **AdministratorAccess**

**2.2.7 Amazon EKS**

- **Purpose:** Container orchestration using Kubernetes.

- **Configuration:**

  - Cluster:

    - Cluster Name: **terra-eks-cluster**
    - Cluster Version: **1.28**
    - VPC: **terra-vpc**
    - Subnets: **10.0.101.0/24**, **10.0.102.0/24**
    - Security Group: **terra-sg**
    - Endpoint Private Access: **false**
    - Endpoint Public Access: **true**

  - Node Group(s): 

    - Node Group Name: **terra-eks-node-group**

    - Scaling Desired Size: **1**

    - Scaling Max Size: **3**

    - Scaling Min Size: **1**

    - Instance Types: **t2.micro**

    - Key Pair: **chaitu-aws-IN**

      

**3. Security Considerations**

- **VPC Security:**

  - Private subnets for sensitive resources.
  - Network ACLs for additional control.

- **Security Groups:**

  - Principle of least privilege for inbound and outbound rules.

- **IAM Roles:**

  - Least privilege principle for EC2 instances and EKS cluster.

    

**4. Deployment Process**

**4.1 Terraform Scripts**

- Organized into modular components for maintainability.
- Scripts include variables, resources, and outputs.

**4.2 Terraform Commands**

- Initialize: **terraform init**
- Plan: **terraform plan**
- Apply: **terraform apply**
- Destroy: **terraform destroy** 

**4.3 Jenkins**

- Deployed the above terraform code in various stages using Jenkins pipeline with following stages:
  - Git-Checkout
  - Creating S3-DynamoDB
  - Initializing Terraform
  - Validating Terraform Configuration
  - Planning for Platform Creation
  - Creating Platform
- Destroyed the terraform platform in various stages using Jenkins pipeline with following stages:
  - Destroying Platform
  - Destroying S3-DynamoDB



**5. Testing**

**5.1 Unit Testing for Terraform Code**

- **Steps:**
  - Run Terraform validate for each module.
  - Execute Terraform plan for each module.
  
- **Expected Outcome:**
  - No validation errors or warnings.
  - The plan should show the expected changes.
  
- **Acceptance Criteria:**
  - All modules pass validation.
  
  - Terraform plans are as expected.
  
    
  
  <img width="572" alt="terraform-validate-platform" src="https://github.com/chaitanya-pandeswara/online-boutique-platform-terraform/assets/57262203/21cfef22-0bd9-4315-bbc3-cdcee339db90">
  
  
  
  ```
  lenovo@DESKTOP /d/DevOps-Dynamics-Project/terraform-platform-code/dev
  $ terraform plan -var-file=dev.tfvars
  
  Terraform used the selected providers to generate the following execution
  plan. Resource actions are indicated with the following symbols:
    + create
  
  Terraform will perform the following actions:
  
    # module.eks.aws_eks_cluster.terra_eks will be created
    + resource "aws_eks_cluster" "terra_eks" {
        + arn                   = (known after apply)
        + certificate_authority = (known after apply)
        + cluster_id            = (known after apply)
        + created_at            = (known after apply)
        + endpoint              = (known after apply)
        + id                    = (known after apply)
        + identity              = (known after apply)
        + name                  = "terra-eks-cluster"
        + platform_version      = (known after apply)
        + role_arn              = (known after apply)
        + status                = (known after apply)
        + tags                  = {
            + "env" = "dev"
          }
        + tags_all              = {
            + "env" = "dev"
          }
        + version               = (known after apply)
  
        + vpc_config {
            + cluster_security_group_id = (known after apply)
            + endpoint_private_access   = false
            + endpoint_public_access    = true
            + public_access_cidrs       = [
                + "0.0.0.0/0",
              ]
            + security_group_ids        = (known after apply)
            + subnet_ids                = (known after apply)
            + vpc_id                    = (known after apply)
          }
      }
  
    # module.eks.aws_eks_node_group.terra_eks_node will be created
    + resource "aws_eks_node_group" "terra_eks_node" {
        + ami_type               = (known after apply)
        + arn                    = (known after apply)
        + capacity_type          = (known after apply)
        + cluster_name           = "terra-eks-cluster"
        + disk_size              = (known after apply)
        + id                     = (known after apply)
        + instance_types         = [
            + "t2.micro",
          ]
        + node_group_name        = "terra-eks-node-group"
        + node_group_name_prefix = (known after apply)
        + node_role_arn          = (known after apply)
        + release_version        = (known after apply)
        + resources              = (known after apply)
        + status                 = (known after apply)
        + subnet_ids             = (known after apply)
        + tags_all               = (known after apply)
        + version                = (known after apply)
  
        + remote_access {
            + ec2_ssh_key               = "chaitu-aws-IN"
            + source_security_group_ids = (known after apply)
          }
  
        + scaling_config {
            + desired_size = 1
            + max_size     = 2
            + min_size     = 1
          }
      }
  
    # module.iam-roles-policies.aws_iam_role.eks_cluster_role will be created
    + resource "aws_iam_role" "eks_cluster_role" {
        + arn                   = (known after apply)
        + assume_role_policy    = jsonencode(
              {
                + Statement = [
                    + {
                        + Action    = "sts:AssumeRole"
                        + Effect    = "Allow"
                        + Principal = {
                            + Service = "eks.amazonaws.com"
                          }
                      },
                  ]
                + Version   = "2012-10-17"
              }
          )
        + create_date           = (known after apply)
        + force_detach_policies = false
        + id                    = (known after apply)
        + managed_policy_arns   = (known after apply)
        + max_session_duration  = 3600
        + name                  = "eksClusterRole"
        + name_prefix           = (known after apply)
        + path                  = "/"
        + tags                  = {
            + "env" = "dev"
          }
        + tags_all              = {
            + "env" = "dev"
          }
        + unique_id             = (known after apply)
      }
  
    # module.iam-roles-policies.aws_iam_role.eks_node_group_role will be created
    + resource "aws_iam_role" "eks_node_group_role" {
        + arn                   = (known after apply)
        + assume_role_policy    = jsonencode(
              {
                + Statement = [
                    + {
                        + Action    = "sts:AssumeRole"
                        + Effect    = "Allow"
                        + Principal = {
                            + Service = "ec2.amazonaws.com"
                          }
                      },
                  ]
                + Version   = "2012-10-17"
              }
          )
        + create_date           = (known after apply)
        + force_detach_policies = false
        + id                    = (known after apply)
        + managed_policy_arns   = (known after apply)
        + max_session_duration  = 3600
        + name                  = "eksNodeGroupRole"
        + name_prefix           = (known after apply)
        + path                  = "/"
        + tags                  = {
            + "env" = "dev"
          }
        + tags_all              = {
            + "env" = "dev"
          }
        + unique_id             = (known after apply)
      }
  
    # module.iam-roles-policies.aws_iam_role_policy_attachment.policy_AmazonEC2ContainerRegistryReadOnly will be created
    + resource "aws_iam_role_policy_attachment" "policy_AmazonEC2ContainerRegistryReadOnly" {
        + id         = (known after apply)
        + policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
        + role       = "eksNodeGroupRole"
      }
  
    # module.iam-roles-policies.aws_iam_role_policy_attachment.policy_AmazonEKSClusterPolicy will be created
    + resource "aws_iam_role_policy_attachment" "policy_AmazonEKSClusterPolicy" {
        + id         = (known after apply)
        + policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
        + role       = "eksClusterRole"
      }
  
    # module.iam-roles-policies.aws_iam_role_policy_attachment.policy_AmazonEKSVPCResourceController will be created
    + resource "aws_iam_role_policy_attachment" "policy_AmazonEKSVPCResourceController" {
        + id         = (known after apply)
        + policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
        + role       = "eksClusterRole"
      }
  
    # module.iam-roles-policies.aws_iam_role_policy_attachment.policy_AmazonEKSWorkerNodePolicy will be created
    + resource "aws_iam_role_policy_attachment" "policy_AmazonEKSWorkerNodePolicy" {
        + id         = (known after apply)
        + policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
        + role       = "eksNodeGroupRole"
      }
  
    # module.iam-roles-policies.aws_iam_role_policy_attachment.policy_AmazonEKS_CNI_Policy will be created
    + resource "aws_iam_role_policy_attachment" "policy_AmazonEKS_CNI_Policy" {
        + id         = (known after apply)
        + policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
        + role       = "eksNodeGroupRole"
      }
  
    # module.igw.aws_internet_gateway.terra_igw will be created
    + resource "aws_internet_gateway" "terra_igw" {
        + arn      = (known after apply)
        + id       = (known after apply)
        + owner_id = (known after apply)
        + tags     = {
            + "Name" = "terra-igw"
            + "env"  = "dev"
          }
        + tags_all = {
            + "Name" = "terra-igw"
            + "env"  = "dev"
          }
        + vpc_id   = (known after apply)
      }
  
    # module.route-table.aws_default_route_table.terra_rtb will be created
    + resource "aws_default_route_table" "terra_rtb" {
        + arn                    = (known after apply)
        + default_route_table_id = (known after apply)
        + id                     = (known after apply)
        + owner_id               = (known after apply)
        + route                  = [
            + {
                + cidr_block                 = "0.0.0.0/0"
                + core_network_arn           = ""
                + destination_prefix_list_id = ""
                + egress_only_gateway_id     = ""
                + gateway_id                 = (known after apply)
                + instance_id                = ""
                + ipv6_cidr_block            = ""
                + nat_gateway_id             = ""
                + network_interface_id       = ""
                + transit_gateway_id         = ""
                + vpc_endpoint_id            = ""
                + vpc_peering_connection_id  = ""
              },
          ]
        + tags                   = {
            + "Name" = "terra-rtb"
            + "env"  = "dev"
          }
        + tags_all               = {
            + "Name" = "terra-rtb"
            + "env"  = "dev"
          }
        + vpc_id                 = (known after apply)
      }
  
    # module.route-table.aws_route_table_association.terra_rtb_a[0] will be created
    + resource "aws_route_table_association" "terra_rtb_a" {
        + id             = (known after apply)
        + route_table_id = (known after apply)
        + subnet_id      = (known after apply)
      }
  
    # module.route-table.aws_route_table_association.terra_rtb_a[1] will be created
    + resource "aws_route_table_association" "terra_rtb_a" {
        + id             = (known after apply)
        + route_table_id = (known after apply)
        + subnet_id      = (known after apply)
      }
  
    # module.security-group.aws_security_group.terra_sg will be created
    + resource "aws_security_group" "terra_sg" {
        + arn                    = (known after apply)
        + description            = "To provide access to Chaitanya."
        + egress                 = [
            + {
                + cidr_blocks      = [
                    + "0.0.0.0/0",
                  ]
                + description      = ""
                + from_port        = 0
                + ipv6_cidr_blocks = []
                + prefix_list_ids  = []
                + protocol         = "-1"
                + security_groups  = []
                + self             = false
                + to_port          = 0
              },
          ]
        + id                     = (known after apply)
        + ingress                = [
            + {
                + cidr_blocks      = [
                    + "0.0.0.0/0",
                  ]
                + description      = "HTTP access to Chaitanya"
                + from_port        = 80
                + ipv6_cidr_blocks = []
                + prefix_list_ids  = []
                + protocol         = "tcp"
                + security_groups  = []
                + self             = false
                + to_port          = 80
              },
            + {
                + cidr_blocks      = [
                    + "0.0.0.0/0",
                  ]
                + description      = "SSH access to Chaitanya"
                + from_port        = 22
                + ipv6_cidr_blocks = []
                + prefix_list_ids  = []
                + protocol         = "tcp"
                + security_groups  = []
                + self             = false
                + to_port          = 22
              },
          ]
        + name                   = "terra-sg"
        + name_prefix            = (known after apply)
        + owner_id               = (known after apply)
        + revoke_rules_on_delete = false
        + tags                   = {
            + "Name" = "terra-sg"
            + "env"  = "dev"
          }
        + tags_all               = {
            + "Name" = "terra-sg"
            + "env"  = "dev"
          }
        + vpc_id                 = (known after apply)
      }
  
    # module.vpc.aws_subnet.terra_pub[0] will be created
    + resource "aws_subnet" "terra_pub" {
        + arn                                            = (known after apply)
        + assign_ipv6_address_on_creation                = false
        + availability_zone                              = "ap-south-1a"
        + availability_zone_id                           = (known after apply)
        + cidr_block                                     = "10.0.101.0/24"
        + enable_dns64                                   = false
        + enable_resource_name_dns_a_record_on_launch    = false
        + enable_resource_name_dns_aaaa_record_on_launch = false
        + id                                             = (known after apply)
        + ipv6_cidr_block_association_id                 = (known after apply)
        + ipv6_native                                    = false
        + map_public_ip_on_launch                        = true
        + owner_id                                       = (known after apply)
        + private_dns_hostname_type_on_launch            = (known after apply)
        + tags                                           = {
            + "Name" = "terra-pub1"
            + "env"  = "dev"
          }
        + tags_all                                       = {
            + "Name" = "terra-pub1"
            + "env"  = "dev"
          }
        + vpc_id                                         = (known after apply)
      }
  
    # module.vpc.aws_subnet.terra_pub[1] will be created
    + resource "aws_subnet" "terra_pub" {
        + arn                                            = (known after apply)
        + assign_ipv6_address_on_creation                = false
        + availability_zone                              = "ap-south-1b"
        + availability_zone_id                           = (known after apply)
        + cidr_block                                     = "10.0.102.0/24"
        + enable_dns64                                   = false
        + enable_resource_name_dns_a_record_on_launch    = false
        + enable_resource_name_dns_aaaa_record_on_launch = false
        + id                                             = (known after apply)
        + ipv6_cidr_block_association_id                 = (known after apply)
        + ipv6_native                                    = false
        + map_public_ip_on_launch                        = true
        + owner_id                                       = (known after apply)
        + private_dns_hostname_type_on_launch            = (known after apply)
        + tags                                           = {
            + "Name" = "terra-pub2"
            + "env"  = "dev"
          }
        + tags_all                                       = {
            + "Name" = "terra-pub2"
            + "env"  = "dev"
          }
        + vpc_id                                         = (known after apply)
      }
  
    # module.vpc.aws_vpc.terra_vpc will be created
    + resource "aws_vpc" "terra_vpc" {
        + arn                                  = (known after apply)
        + cidr_block                           = "10.0.0.0/16"
        + default_network_acl_id               = (known after apply)
        + default_route_table_id               = (known after apply)
        + default_security_group_id            = (known after apply)
        + dhcp_options_id                      = (known after apply)
        + enable_dns_hostnames                 = true
        + enable_dns_support                   = true
        + enable_network_address_usage_metrics = (known after apply)
        + id                                   = (known after apply)
        + instance_tenancy                     = "default"
        + ipv6_association_id                  = (known after apply)
        + ipv6_cidr_block                      = (known after apply)
        + ipv6_cidr_block_network_border_group = (known after apply)
        + main_route_table_id                  = (known after apply)
        + owner_id                             = (known after apply)
        + tags                                 = {
            + "Name" = "terra-vpc"
            + "env"  = "dev"
          }
        + tags_all                             = {
            + "Name" = "terra-vpc"
            + "env"  = "dev"
          }
      }
  
  Plan: 17 to add, 0 to change, 0 to destroy.
  ```
  
  ​		

​	

**5.2 Integration Testing**

- **Steps:**
  - Run Terraform apply & destroy for the entire infrastructure.
  
- **Expected Outcome:**
  - All resources are created and destroyed without errors.
  
- **Acceptance Criteria:**
  
  - No resource conflicts or dependencies issues.
  - All resources created and destroyed as expected. 
  
  ```
  lenovo@DESKTOP /d/DevOps-Dynamics-Project/terraform-platform-code/dev
  $ terraform apply -var-file=dev.tfvars -auto-approve
  
  Terraform used the selected providers to generate the following execution
  plan. Resource actions are indicated with the following symbols:
    + create
  
  Terraform will perform the following actions:
  
    # module.eks.aws_eks_cluster.terra_eks will be created
    + resource "aws_eks_cluster" "terra_eks" {
        + arn                   = (known after apply)
        + certificate_authority = (known after apply)
        + cluster_id            = (known after apply)
        + created_at            = (known after apply)
        + endpoint              = (known after apply)
        + id                    = (known after apply)
        + identity              = (known after apply)
        + name                  = "terra-eks-cluster"
        + platform_version      = (known after apply)
        + role_arn              = (known after apply)
        + status                = (known after apply)
        + tags                  = {
            + "env" = "dev"
          }
        + tags_all              = {
            + "env" = "dev"
          }
        + version               = (known after apply)
  
        + vpc_config {
            + cluster_security_group_id = (known after apply)
            + endpoint_private_access   = false
            + endpoint_public_access    = true
            + public_access_cidrs       = [
                + "0.0.0.0/0",
              ]
            + security_group_ids        = (known after apply)
            + subnet_ids                = (known after apply)
            + vpc_id                    = (known after apply)
          }
      }
  
    # module.eks.aws_eks_node_group.terra_eks_node will be created
    + resource "aws_eks_node_group" "terra_eks_node" {
        + ami_type               = (known after apply)
        + arn                    = (known after apply)
        + capacity_type          = (known after apply)
        + cluster_name           = "terra-eks-cluster"
        + disk_size              = (known after apply)
        + id                     = (known after apply)
        + instance_types         = [
            + "t2.micro",
          ]
        + node_group_name        = "terra-eks-node-group"
        + node_group_name_prefix = (known after apply)
        + node_role_arn          = (known after apply)
        + release_version        = (known after apply)
        + resources              = (known after apply)
        + status                 = (known after apply)
        + subnet_ids             = (known after apply)
        + tags_all               = (known after apply)
        + version                = (known after apply)
  
        + remote_access {
            + ec2_ssh_key               = "chaitu-aws-IN"
            + source_security_group_ids = (known after apply)
          }
  
        + scaling_config {
            + desired_size = 1
            + max_size     = 2
            + min_size     = 1
          }
      }
  
    # module.iam-roles-policies.aws_iam_role.eks_cluster_role will be created
    + resource "aws_iam_role" "eks_cluster_role" {
        + arn                   = (known after apply)
        + assume_role_policy    = jsonencode(
              {
                + Statement = [
                    + {
                        + Action    = "sts:AssumeRole"
                        + Effect    = "Allow"
                        + Principal = {
                            + Service = "eks.amazonaws.com"
                          }
                      },
                  ]
                + Version   = "2012-10-17"
              }
          )
        + create_date           = (known after apply)
        + force_detach_policies = false
        + id                    = (known after apply)
        + managed_policy_arns   = (known after apply)
        + max_session_duration  = 3600
        + name                  = "eksClusterRole"
        + name_prefix           = (known after apply)
        + path                  = "/"
        + tags                  = {
            + "env" = "dev"
          }
        + tags_all              = {
            + "env" = "dev"
          }
        + unique_id             = (known after apply)
      }
  
    # module.iam-roles-policies.aws_iam_role.eks_node_group_role will be created
    + resource "aws_iam_role" "eks_node_group_role" {
        + arn                   = (known after apply)
        + assume_role_policy    = jsonencode(
              {
                + Statement = [
                    + {
                        + Action    = "sts:AssumeRole"
                        + Effect    = "Allow"
                        + Principal = {
                            + Service = "ec2.amazonaws.com"
                          }
                      },
                  ]
                + Version   = "2012-10-17"
              }
          )
        + create_date           = (known after apply)
        + force_detach_policies = false
        + id                    = (known after apply)
        + managed_policy_arns   = (known after apply)
        + max_session_duration  = 3600
        + name                  = "eksNodeGroupRole"
        + name_prefix           = (known after apply)
        + path                  = "/"
        + tags                  = {
            + "env" = "dev"
          }
        + tags_all              = {
            + "env" = "dev"
          }
        + unique_id             = (known after apply)
      }
  
    # module.iam-roles-policies.aws_iam_role_policy_attachment.policy_AmazonEC2ContainerRegistryReadOnly will be created
    + resource "aws_iam_role_policy_attachment" "policy_AmazonEC2ContainerRegistryReadOnly" {
        + id         = (known after apply)
        + policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
        + role       = "eksNodeGroupRole"
      }
  
    # module.iam-roles-policies.aws_iam_role_policy_attachment.policy_AmazonEKSClusterPolicy will be created
    + resource "aws_iam_role_policy_attachment" "policy_AmazonEKSClusterPolicy" {
        + id         = (known after apply)
        + policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
        + role       = "eksClusterRole"
      }
  
    # module.iam-roles-policies.aws_iam_role_policy_attachment.policy_AmazonEKSVPCResourceController will be created
    + resource "aws_iam_role_policy_attachment" "policy_AmazonEKSVPCResourceController" {
        + id         = (known after apply)
        + policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
        + role       = "eksClusterRole"
      }
  
    # module.iam-roles-policies.aws_iam_role_policy_attachment.policy_AmazonEKSWorkerNodePolicy will be created
    + resource "aws_iam_role_policy_attachment" "policy_AmazonEKSWorkerNodePolicy" {
        + id         = (known after apply)
        + policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
        + role       = "eksNodeGroupRole"
      }
  
    # module.iam-roles-policies.aws_iam_role_policy_attachment.policy_AmazonEKS_CNI_Policy will be created
    + resource "aws_iam_role_policy_attachment" "policy_AmazonEKS_CNI_Policy" {
        + id         = (known after apply)
        + policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
        + role       = "eksNodeGroupRole"
      }
  
    # module.igw.aws_internet_gateway.terra_igw will be created
    + resource "aws_internet_gateway" "terra_igw" {
        + arn      = (known after apply)
        + id       = (known after apply)
        + owner_id = (known after apply)
        + tags     = {
            + "Name" = "terra-igw"
            + "env"  = "dev"
          }
        + tags_all = {
            + "Name" = "terra-igw"
            + "env"  = "dev"
          }
        + vpc_id   = (known after apply)
      }
  
    # module.route-table.aws_default_route_table.terra_rtb will be created
    + resource "aws_default_route_table" "terra_rtb" {
        + arn                    = (known after apply)
        + default_route_table_id = (known after apply)
        + id                     = (known after apply)
        + owner_id               = (known after apply)
        + route                  = [
            + {
                + cidr_block                 = "0.0.0.0/0"
                + core_network_arn           = ""
                + destination_prefix_list_id = ""
                + egress_only_gateway_id     = ""
                + gateway_id                 = (known after apply)
                + instance_id                = ""
                + ipv6_cidr_block            = ""
                + nat_gateway_id             = ""
                + network_interface_id       = ""
                + transit_gateway_id         = ""
                + vpc_endpoint_id            = ""
                + vpc_peering_connection_id  = ""
              },
          ]
        + tags                   = {
            + "Name" = "terra-rtb"
            + "env"  = "dev"
          }
        + tags_all               = {
            + "Name" = "terra-rtb"
            + "env"  = "dev"
          }
        + vpc_id                 = (known after apply)
      }
  
    # module.route-table.aws_route_table_association.terra_rtb_a[0] will be created
    + resource "aws_route_table_association" "terra_rtb_a" {
        + id             = (known after apply)
        + route_table_id = (known after apply)
        + subnet_id      = (known after apply)
      }
  
    # module.route-table.aws_route_table_association.terra_rtb_a[1] will be created
    + resource "aws_route_table_association" "terra_rtb_a" {
        + id             = (known after apply)
        + route_table_id = (known after apply)
        + subnet_id      = (known after apply)
      }
  
    # module.security-group.aws_security_group.terra_sg will be created
    + resource "aws_security_group" "terra_sg" {
        + arn                    = (known after apply)
        + description            = "To provide access to Chaitanya."
        + egress                 = [
            + {
                + cidr_blocks      = [
                    + "0.0.0.0/0",
                  ]
                + description      = ""
                + from_port        = 0
                + ipv6_cidr_blocks = []
                + prefix_list_ids  = []
                + protocol         = "-1"
                + security_groups  = []
                + self             = false
                + to_port          = 0
              },
          ]
        + id                     = (known after apply)
        + ingress                = [
            + {
                + cidr_blocks      = [
                    + "0.0.0.0/0",
                  ]
                + description      = "HTTP access to Chaitanya"
                + from_port        = 80
                + ipv6_cidr_blocks = []
                + prefix_list_ids  = []
                + protocol         = "tcp"
                + security_groups  = []
                + self             = false
                + to_port          = 80
              },
            + {
                + cidr_blocks      = [
                    + "0.0.0.0/0",
                  ]
                + description      = "SSH access to Chaitanya"
                + from_port        = 22
                + ipv6_cidr_blocks = []
                + prefix_list_ids  = []
                + protocol         = "tcp"
                + security_groups  = []
                + self             = false
                + to_port          = 22
              },
          ]
        + name                   = "terra-sg"
        + name_prefix            = (known after apply)
        + owner_id               = (known after apply)
        + revoke_rules_on_delete = false
        + tags                   = {
            + "Name" = "terra-sg"
            + "env"  = "dev"
          }
        + tags_all               = {
            + "Name" = "terra-sg"
            + "env"  = "dev"
          }
        + vpc_id                 = (known after apply)
      }
  
    # module.vpc.aws_subnet.terra_pub[0] will be created
    + resource "aws_subnet" "terra_pub" {
        + arn                                            = (known after apply)
        + assign_ipv6_address_on_creation                = false
        + availability_zone                              = "ap-south-1a"
        + availability_zone_id                           = (known after apply)
        + cidr_block                                     = "10.0.101.0/24"
        + enable_dns64                                   = false
        + enable_resource_name_dns_a_record_on_launch    = false
        + enable_resource_name_dns_aaaa_record_on_launch = false
        + id                                             = (known after apply)
        + ipv6_cidr_block_association_id                 = (known after apply)
        + ipv6_native                                    = false
        + map_public_ip_on_launch                        = true
        + owner_id                                       = (known after apply)
        + private_dns_hostname_type_on_launch            = (known after apply)
        + tags                                           = {
            + "Name" = "terra-pub1"
            + "env"  = "dev"
          }
        + tags_all                                       = {
            + "Name" = "terra-pub1"
            + "env"  = "dev"
          }
        + vpc_id                                         = (known after apply)
      }
  
    # module.vpc.aws_subnet.terra_pub[1] will be created
    + resource "aws_subnet" "terra_pub" {
        + arn                                            = (known after apply)
        + assign_ipv6_address_on_creation                = false
        + availability_zone                              = "ap-south-1b"
        + availability_zone_id                           = (known after apply)
        + cidr_block                                     = "10.0.102.0/24"
        + enable_dns64                                   = false
        + enable_resource_name_dns_a_record_on_launch    = false
        + enable_resource_name_dns_aaaa_record_on_launch = false
        + id                                             = (known after apply)
        + ipv6_cidr_block_association_id                 = (known after apply)
        + ipv6_native                                    = false
        + map_public_ip_on_launch                        = true
        + owner_id                                       = (known after apply)
        + private_dns_hostname_type_on_launch            = (known after apply)
        + tags                                           = {
            + "Name" = "terra-pub2"
            + "env"  = "dev"
          }
        + tags_all                                       = {
            + "Name" = "terra-pub2"
            + "env"  = "dev"
          }
        + vpc_id                                         = (known after apply)
      }
  
    # module.vpc.aws_vpc.terra_vpc will be created
    + resource "aws_vpc" "terra_vpc" {
        + arn                                  = (known after apply)
        + cidr_block                           = "10.0.0.0/16"
        + default_network_acl_id               = (known after apply)
        + default_route_table_id               = (known after apply)
        + default_security_group_id            = (known after apply)
        + dhcp_options_id                      = (known after apply)
        + enable_dns_hostnames                 = true
        + enable_dns_support                   = true
        + enable_network_address_usage_metrics = (known after apply)
        + id                                   = (known after apply)
        + instance_tenancy                     = "default"
        + ipv6_association_id                  = (known after apply)
        + ipv6_cidr_block                      = (known after apply)
        + ipv6_cidr_block_network_border_group = (known after apply)
        + main_route_table_id                  = (known after apply)
        + owner_id                             = (known after apply)
        + tags                                 = {
            + "Name" = "terra-vpc"
            + "env"  = "dev"
          }
        + tags_all                             = {
            + "Name" = "terra-vpc"
            + "env"  = "dev"
          }
      }
  
  Plan: 17 to add, 0 to change, 0 to destroy.
  module.vpc.aws_vpc.terra_vpc: Creating...
  module.iam-roles-policies.aws_iam_role.eks_cluster_role: Creating...
  module.iam-roles-policies.aws_iam_role.eks_node_group_role: Creating...
  module.iam-roles-policies.aws_iam_role.eks_cluster_role: Creation complete after 2s [id=eksClusterRole]
  module.iam-roles-policies.aws_iam_role_policy_attachment.policy_AmazonEKSClusterPolicy: Creating...
  module.iam-roles-policies.aws_iam_role_policy_attachment.policy_AmazonEKSVPCResourceController: Creating...
  module.iam-roles-policies.aws_iam_role.eks_node_group_role: Creation complete after 3s [id=eksNodeGroupRole]
  module.iam-roles-policies.aws_iam_role_policy_attachment.policy_AmazonEKSWorkerNodePolicy: Creating...
  module.iam-roles-policies.aws_iam_role_policy_attachment.policy_AmazonEC2ContainerRegistryReadOnly: Creating...
  module.iam-roles-policies.aws_iam_role_policy_attachment.policy_AmazonEKS_CNI_Policy: Creating...
  module.iam-roles-policies.aws_iam_role_policy_attachment.policy_AmazonEKSVPCResourceController: Creation complete after 1s [id=eksClusterRole-20231117061041306900000001]
  module.iam-roles-policies.aws_iam_role_policy_attachment.policy_AmazonEKSClusterPolicy: Creation complete after 1s [id=eksClusterRole-20231117061041342000000002]
  module.iam-roles-policies.aws_iam_role_policy_attachment.policy_AmazonEKS_CNI_Policy: Creation complete after 1s [id=eksNodeGroupRole-20231117061042200300000004]
  module.iam-roles-policies.aws_iam_role_policy_attachment.policy_AmazonEKSWorkerNodePolicy: Creation complete after 1s [id=eksNodeGroupRole-20231117061042026900000003]
  module.iam-roles-policies.aws_iam_role_policy_attachment.policy_AmazonEC2ContainerRegistryReadOnly: Creation complete after 1s [id=eksNodeGroupRole-20231117061042273800000005]
  module.vpc.aws_vpc.terra_vpc: Still creating... [10s elapsed]
  module.vpc.aws_vpc.terra_vpc: Creation complete after 11s [id=vpc-0284dbf61e6bb3c4b]
  module.igw.aws_internet_gateway.terra_igw: Creating...
  module.vpc.aws_subnet.terra_pub[1]: Creating...
  module.vpc.aws_subnet.terra_pub[0]: Creating...
  module.security-group.aws_security_group.terra_sg: Creating...
  module.igw.aws_internet_gateway.terra_igw: Creation complete after 1s [id=igw-0ce58418740d771fa]
  module.route-table.aws_default_route_table.terra_rtb: Creating...
  module.route-table.aws_default_route_table.terra_rtb: Creation complete after 0s [id=rtb-0622f2cd670da4ec2]
  module.security-group.aws_security_group.terra_sg: Creation complete after 2s [id=sg-04e830d3534906b05]
  module.vpc.aws_subnet.terra_pub[0]: Still creating... [10s elapsed]
  module.vpc.aws_subnet.terra_pub[1]: Still creating... [10s elapsed]
  module.vpc.aws_subnet.terra_pub[0]: Creation complete after 11s [id=subnet-058f1b3650cbd5ccc]
  module.vpc.aws_subnet.terra_pub[1]: Creation complete after 11s [id=subnet-07a523b421c4a5e6f]
  module.route-table.aws_route_table_association.terra_rtb_a[0]: Creating...
  module.route-table.aws_route_table_association.terra_rtb_a[1]: Creating...
  module.eks.aws_eks_cluster.terra_eks: Creating...
  module.route-table.aws_route_table_association.terra_rtb_a[1]: Creation complete after 0s [id=rtbassoc-0c07b2ec6e774b293]
  module.route-table.aws_route_table_association.terra_rtb_a[0]: Creation complete after 1s [id=rtbassoc-026a8907efec121f7]
  module.eks.aws_eks_cluster.terra_eks: Still creating... [10s elapsed]
  module.eks.aws_eks_cluster.terra_eks: Still creating... [6m0s elapsed]
  module.eks.aws_eks_cluster.terra_eks: Creation complete after 6m1s [id=terra-eks-cluster]
  module.eks.aws_eks_node_group.terra_eks_node: Creating...
  module.eks.aws_eks_node_group.terra_eks_node: Still creating... [10s elapsed]
  module.eks.aws_eks_node_group.terra_eks_node: Still creating... [3m20s elapsed]
  module.eks.aws_eks_node_group.terra_eks_node: Creation complete after 3m21s [id=terra-eks-cluster:terra-eks-node-group]
  
  Apply complete! Resources: 17 added, 0 changed, 0 destroyed.
  ```
  
  ```
  lenovo@DESKTOP /d/DevOps-Dynamics-Project/terraform-platform-code/dev
  $ terraform destroy -var-file=dev.tfvars -auto-approve
  module.vpc.aws_vpc.terra_vpc: Refreshing state... [id=vpc-0284dbf61e6bb3c4b]
  module.iam-roles-policies.aws_iam_role.eks_cluster_role: Refreshing state... [id=eksClusterRole]
  module.iam-roles-policies.aws_iam_role.eks_node_group_role: Refreshing state... [id=eksNodeGroupRole]
  module.igw.aws_internet_gateway.terra_igw: Refreshing state... [id=igw-0ce58418740d771fa]
  module.vpc.aws_subnet.terra_pub[0]: Refreshing state... [id=subnet-058f1b3650cbd5ccc]
  module.vpc.aws_subnet.terra_pub[1]: Refreshing state... [id=subnet-07a523b421c4a5e6f]
  module.security-group.aws_security_group.terra_sg: Refreshing state... [id=sg-04e830d3534906b05]
  module.route-table.aws_default_route_table.terra_rtb: Refreshing state... [id=rtb-0622f2cd670da4ec2]
  module.route-table.aws_route_table_association.terra_rtb_a[0]: Refreshing state... [id=rtbassoc-026a8907efec121f7]
  module.route-table.aws_route_table_association.terra_rtb_a[1]: Refreshing state... [id=rtbassoc-0c07b2ec6e774b293]
  module.iam-roles-policies.aws_iam_role_policy_attachment.policy_AmazonEKSWorkerNodePolicy: Refreshing state... [id=eksNodeGroupRole-20231117061042026900000003]
  module.iam-roles-policies.aws_iam_role_policy_attachment.policy_AmazonEC2ContainerRegistryReadOnly: Refreshing state... [id=eksNodeGroupRole-20231117061042273800000005]
  module.iam-roles-policies.aws_iam_role_policy_attachment.policy_AmazonEKS_CNI_Policy: Refreshing state... [id=eksNodeGroupRole-20231117061042200300000004]
  module.iam-roles-policies.aws_iam_role_policy_attachment.policy_AmazonEKSClusterPolicy: Refreshing state... [id=eksClusterRole-20231117061041342000000002]
  module.iam-roles-policies.aws_iam_role_policy_attachment.policy_AmazonEKSVPCResourceController: Refreshing state... [id=eksClusterRole-20231117061041306900000001]
  module.eks.aws_eks_cluster.terra_eks: Refreshing state... [id=terra-eks-cluster]
  module.eks.aws_eks_node_group.terra_eks_node: Refreshing state... [id=terra-eks-cluster:terra-eks-node-group]
  
  Terraform used the selected providers to generate the following execution
  plan. Resource actions are indicated with the following symbols:
    - destroy
  
  Terraform will perform the following actions:
  
    # module.eks.aws_eks_cluster.terra_eks will be destroyed
    - resource "aws_eks_cluster" "terra_eks" {
        - arn                       = "arn:aws:eks:ap-south-1:292969846548:cluster/terra-eks-cluster" -> null
        - certificate_authority     = [
            - {
                - data = "LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURCVENDQWUyZ0F3SUJBZ0lJSnd4S3hiV3o2V1l3RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TXpFeE1UY3dOakE1TlROYUZ3MHpNekV4TVRRd05qRTBOVE5hTUJVeApFekFSQmdOVkJBTVRDbXQxWW1WeWJtVjBaWE13Z2dFaU1BMEdDU3FHU0liM0RRRUJBUVVBQTRJQkR3QXdnZ0VLCkFvSUJBUURFYUpmZEwwRlFCTmYyeVZ4OHZydW1DZmRpbk1zUXc1cm45SmtkeFlLTUprZlp6UDQ1ZGQxd3lud3gKV2djdWNKaFZMSFpsWVNpMC85MWczdlpUSTRoNGtjekVqUEg1b3hKaDJoQldvbitqN3UwdXV3N3JHcy9YTFNZVwpOUFp1K05YVHZ4SlJJckxqa0tLT3BOd1pGOXdnSm8yL1RtMVNLdUozMW1TZWFEVzJ3UWl4bGduU1RBS0s3Q3A5Clk4WVpmS2Y3TDQ4Q1NZZlZyNTkrMzk0aXhqNW9rUUwzMFdwV1dWbnNjbmRBRVRCSi80VGNHWkhEckUrYTJwTkkKY2RBekV0dHZmOFNYODRYSkZwUVZrN0t1dUk5VmNpSjFwQ2s3QVZWbW0zRWVhY0pRYnNYODNvRjkzeGhQeHhObgp5ZWdpREFIb3RVZEFIWlZBN3F0dlcrNjNIc2pEQWdNQkFBR2pXVEJYTUE0R0ExVWREd0VCL3dRRUF3SUNwREFQCkJnTlZIUk1CQWY4RUJUQURBUUgvTUIwR0ExVWREZ1FXQkJRM2lqTytjeVVraTYxV3pzMThPRkozemhpVkZUQVYKQmdOVkhSRUVEakFNZ2dwcmRXSmxjbTVsZEdWek1BMEdDU3FHU0liM0RRRUJDd1VBQTRJQkFRQ0dYcGhtdVpjbgpieW11R2dxRWt0azdCS0xDUEQ5VzRkZDdpZE9Db1MwMXIxUGsxdTZyZ2xyYmNIaERYSTd0NXE1R2l3MUdWaXZBCkV2YVZPS1FyWEVoSnh0bGtpY0lMTDU4VmdTdU1VcUxDU0RLeWFPNjh5Nkw0WGJlM2FvSk5COEZ1OWZaS0ZFNEUKMVJ6S2dQNEdiNVYvRXdyVlVPTW0zTEZOQ0hKaU96RnM0RlQxZjRrRmgwU0Rqc3hVSEJkQVVKVG5iNnFkMUh2MQpLZldWeitZdlZXeXZwbngwdjhYSjUycUJkWWtSYWVmUG1HbWFQM3VGejZlS0xRajVvRzJZMnFCdjM5YlE0S0poCk5kSjBwdUdxbitjd09SaEJkTzd4YnBjSWFZUTFOQk1iQkdFdjU1VVljaHNOY1kxSmFNN3JlRzF2ZDB3U3VkcGMKL08yUElEODhjU0ZPCi0tLS0tRU5EIENFUlRJRklDQVRFLS0tLS0K"
              },
          ] -> null
        - created_at                = "2023-11-17 06:11:02.344 +0000 UTC" -> null
        - enabled_cluster_log_types = [] -> null
        - endpoint                  = "https://8DA5F022B19E30541DB0BCE35F587DA6.gr7.ap-south-1.eks.amazonaws.com" -> null
        - id                        = "terra-eks-cluster" -> null
        - identity                  = [
            - {
                - oidc = [
                    - {
                        - issuer = "https://oidc.eks.ap-south-1.amazonaws.com/id/8DA5F022B19E30541DB0BCE35F587DA6"
                      },
                  ]
              },
          ] -> null
        - name                      = "terra-eks-cluster" -> null
        - platform_version          = "eks.4" -> null
        - role_arn                  = "arn:aws:iam::292969846548:role/eksClusterRole" -> null
        - status                    = "ACTIVE" -> null
        - tags                      = {
            - "env" = "dev"
          } -> null
        - tags_all                  = {
            - "env" = "dev"
          } -> null
        - version                   = "1.28" -> null
  
        - kubernetes_network_config {
            - ip_family         = "ipv4" -> null
            - service_ipv4_cidr = "172.20.0.0/16" -> null
          }
  
        - vpc_config {
            - cluster_security_group_id = "sg-07ca199a040227436" -> null
            - endpoint_private_access   = false -> null
            - endpoint_public_access    = true -> null
            - public_access_cidrs       = [
                - "0.0.0.0/0",
              ] -> null
            - security_group_ids        = [
                - "sg-04e830d3534906b05",
              ] -> null
            - subnet_ids                = [
                - "subnet-058f1b3650cbd5ccc",
                - "subnet-07a523b421c4a5e6f",
              ] -> null
            - vpc_id                    = "vpc-0284dbf61e6bb3c4b" -> null
          }
      }
  
    # module.eks.aws_eks_node_group.terra_eks_node will be destroyed
    - resource "aws_eks_node_group" "terra_eks_node" {
        - ami_type        = "AL2_x86_64" -> null
        - arn             = "arn:aws:eks:ap-south-1:292969846548:nodegroup/terra-eks-cluster/terra-eks-node-group/5ec5edf6-7a30-80c3-46f5-6111f1cb741d" -> null
        - capacity_type   = "ON_DEMAND" -> null
        - cluster_name    = "terra-eks-cluster" -> null
        - disk_size       = 20 -> null
        - id              = "terra-eks-cluster:terra-eks-node-group" -> null
        - instance_types  = [
            - "t2.micro",
          ] -> null
        - labels          = {} -> null
        - node_group_name = "terra-eks-node-group" -> null
        - node_role_arn   = "arn:aws:iam::292969846548:role/eksNodeGroupRole" -> null
        - release_version = "1.28.3-20231106" -> null
        - resources       = [
            - {
                - autoscaling_groups              = [
                    - {
                        - name = "eks-terra-eks-node-group-5ec5edf6-7a30-80c3-46f5-6111f1cb741d"
                      },
                  ]
                - remote_access_security_group_id = "sg-090369d0578fa1bd4"
              },
          ] -> null
        - status          = "ACTIVE" -> null
        - subnet_ids      = [
            - "subnet-058f1b3650cbd5ccc",
            - "subnet-07a523b421c4a5e6f",
          ] -> null
        - tags            = {} -> null
        - tags_all        = {} -> null
        - version         = "1.28" -> null
  
        - remote_access {
            - ec2_ssh_key               = "chaitu-aws-IN" -> null
            - source_security_group_ids = [
                - "sg-04e830d3534906b05",
              ] -> null
          }
  
        - scaling_config {
            - desired_size = 2 -> null
            - max_size     = 2 -> null
            - min_size     = 2 -> null
          }
  
        - update_config {
            - max_unavailable            = 1 -> null
            - max_unavailable_percentage = 0 -> null
          }
      }
  
    # module.iam-roles-policies.aws_iam_role.eks_cluster_role will be destroyed
    - resource "aws_iam_role" "eks_cluster_role" {
        - arn                   = "arn:aws:iam::292969846548:role/eksClusterRole" -> null
        - assume_role_policy    = jsonencode(
              {
                - Statement = [
                    - {
                        - Action    = "sts:AssumeRole"
                        - Effect    = "Allow"
                        - Principal = {
                            - Service = "eks.amazonaws.com"
                          }
                      },
                  ]
                - Version   = "2012-10-17"
              }
          ) -> null
        - create_date           = "2023-11-17T06:10:38Z" -> null
        - force_detach_policies = false -> null
        - id                    = "eksClusterRole" -> null
        - managed_policy_arns   = [
            - "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
            - "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController",
          ] -> null
        - max_session_duration  = 3600 -> null
        - name                  = "eksClusterRole" -> null
        - path                  = "/" -> null
        - tags                  = {
            - "env" = "dev"
          } -> null
        - tags_all              = {
            - "env" = "dev"
          } -> null
        - unique_id             = "AROAUINS5C4KFTWPUCJYS" -> null
      }
  
    # module.iam-roles-policies.aws_iam_role.eks_node_group_role will be destroyed
    - resource "aws_iam_role" "eks_node_group_role" {
        - arn                   = "arn:aws:iam::292969846548:role/eksNodeGroupRole" -> null
        - assume_role_policy    = jsonencode(
              {
                - Statement = [
                    - {
                        - Action    = "sts:AssumeRole"
                        - Effect    = "Allow"
                        - Principal = {
                            - Service = "ec2.amazonaws.com"
                          }
                      },
                  ]
                - Version   = "2012-10-17"
              }
          ) -> null
        - create_date           = "2023-11-17T06:10:39Z" -> null
        - force_detach_policies = false -> null
        - id                    = "eksNodeGroupRole" -> null
        - managed_policy_arns   = [
            - "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
            - "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
            - "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
          ] -> null
        - max_session_duration  = 3600 -> null
        - name                  = "eksNodeGroupRole" -> null
        - path                  = "/" -> null
        - tags                  = {
            - "env" = "dev"
          } -> null
        - tags_all              = {
            - "env" = "dev"
          } -> null
        - unique_id             = "AROAUINS5C4KHSGYJW65Y" -> null
      }
  
    # module.iam-roles-policies.aws_iam_role_policy_attachment.policy_AmazonEC2ContainerRegistryReadOnly will be destroyed
    - resource "aws_iam_role_policy_attachment" "policy_AmazonEC2ContainerRegistryReadOnly" {
        - id         = "eksNodeGroupRole-20231117061042273800000005" -> null
        - policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly" -> null
        - role       = "eksNodeGroupRole" -> null
      }
  
    # module.iam-roles-policies.aws_iam_role_policy_attachment.policy_AmazonEKSClusterPolicy will be destroyed
    - resource "aws_iam_role_policy_attachment" "policy_AmazonEKSClusterPolicy" {
        - id         = "eksClusterRole-20231117061041342000000002" -> null
        - policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy" -> null
        - role       = "eksClusterRole" -> null
      }
  
    # module.iam-roles-policies.aws_iam_role_policy_attachment.policy_AmazonEKSVPCResourceController will be destroyed
    - resource "aws_iam_role_policy_attachment" "policy_AmazonEKSVPCResourceController" {
        - id         = "eksClusterRole-20231117061041306900000001" -> null
        - policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController" -> null
        - role       = "eksClusterRole" -> null
      }
  
    # module.iam-roles-policies.aws_iam_role_policy_attachment.policy_AmazonEKSWorkerNodePolicy will be destroyed
    - resource "aws_iam_role_policy_attachment" "policy_AmazonEKSWorkerNodePolicy" {
        - id         = "eksNodeGroupRole-20231117061042026900000003" -> null
        - policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy" -> null
        - role       = "eksNodeGroupRole" -> null
      }
  
    # module.iam-roles-policies.aws_iam_role_policy_attachment.policy_AmazonEKS_CNI_Policy will be destroyed
    - resource "aws_iam_role_policy_attachment" "policy_AmazonEKS_CNI_Policy" {
        - id         = "eksNodeGroupRole-20231117061042200300000004" -> null
        - policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy" -> null
        - role       = "eksNodeGroupRole" -> null
      }
  
    # module.igw.aws_internet_gateway.terra_igw will be destroyed
    - resource "aws_internet_gateway" "terra_igw" {
        - arn      = "arn:aws:ec2:ap-south-1:292969846548:internet-gateway/igw-0ce58418740d771fa" -> null
        - id       = "igw-0ce58418740d771fa" -> null
        - owner_id = "292969846548" -> null
        - tags     = {
            - "Name" = "terra-igw"
            - "env"  = "dev"
          } -> null
        - tags_all = {
            - "Name" = "terra-igw"
            - "env"  = "dev"
          } -> null
        - vpc_id   = "vpc-0284dbf61e6bb3c4b" -> null
      }
  
    # module.route-table.aws_default_route_table.terra_rtb will be destroyed
    - resource "aws_default_route_table" "terra_rtb" {
        - arn                    = "arn:aws:ec2:ap-south-1:292969846548:route-table/rtb-0622f2cd670da4ec2" -> null
        - default_route_table_id = "rtb-0622f2cd670da4ec2" -> null
        - id                     = "rtb-0622f2cd670da4ec2" -> null
        - owner_id               = "292969846548" -> null
        - propagating_vgws       = [] -> null
        - route                  = [
            - {
                - cidr_block                 = "0.0.0.0/0"
                - core_network_arn           = ""
                - destination_prefix_list_id = ""
                - egress_only_gateway_id     = ""
                - gateway_id                 = "igw-0ce58418740d771fa"
                - instance_id                = ""
                - ipv6_cidr_block            = ""
                - nat_gateway_id             = ""
                - network_interface_id       = ""
                - transit_gateway_id         = ""
                - vpc_endpoint_id            = ""
                - vpc_peering_connection_id  = ""
              },
          ] -> null
        - tags                   = {
            - "Name" = "terra-rtb"
            - "env"  = "dev"
          } -> null
        - tags_all               = {
            - "Name" = "terra-rtb"
            - "env"  = "dev"
          } -> null
        - vpc_id                 = "vpc-0284dbf61e6bb3c4b" -> null
      }
  
    # module.route-table.aws_route_table_association.terra_rtb_a[0] will be destroyed
    - resource "aws_route_table_association" "terra_rtb_a" {
        - id             = "rtbassoc-026a8907efec121f7" -> null
        - route_table_id = "rtb-0622f2cd670da4ec2" -> null
        - subnet_id      = "subnet-058f1b3650cbd5ccc" -> null
      }
  
    # module.route-table.aws_route_table_association.terra_rtb_a[1] will be destroyed
    - resource "aws_route_table_association" "terra_rtb_a" {
        - id             = "rtbassoc-0c07b2ec6e774b293" -> null
        - route_table_id = "rtb-0622f2cd670da4ec2" -> null
        - subnet_id      = "subnet-07a523b421c4a5e6f" -> null
      }
  
    # module.security-group.aws_security_group.terra_sg will be destroyed
    - resource "aws_security_group" "terra_sg" {
        - arn                    = "arn:aws:ec2:ap-south-1:292969846548:security-group/sg-04e830d3534906b05" -> null
        - description            = "To provide access to Chaitanya." -> null
        - egress                 = [
            - {
                - cidr_blocks      = [
                    - "0.0.0.0/0",
                  ]
                - description      = ""
                - from_port        = 0
                - ipv6_cidr_blocks = []
                - prefix_list_ids  = []
                - protocol         = "-1"
                - security_groups  = []
                - self             = false
                - to_port          = 0
              },
          ] -> null
        - id                     = "sg-04e830d3534906b05" -> null
        - ingress                = [
            - {
                - cidr_blocks      = [
                    - "0.0.0.0/0",
                  ]
                - description      = "HTTP access to Chaitanya"
                - from_port        = 80
                - ipv6_cidr_blocks = []
                - prefix_list_ids  = []
                - protocol         = "tcp"
                - security_groups  = []
                - self             = false
                - to_port          = 80
              },
            - {
                - cidr_blocks      = [
                    - "0.0.0.0/0",
                  ]
                - description      = "SSH access to Chaitanya"
                - from_port        = 22
                - ipv6_cidr_blocks = []
                - prefix_list_ids  = []
                - protocol         = "tcp"
                - security_groups  = []
                - self             = false
                - to_port          = 22
              },
          ] -> null
        - name                   = "terra-sg" -> null
        - owner_id               = "292969846548" -> null
        - revoke_rules_on_delete = false -> null
        - tags                   = {
            - "Name" = "terra-sg"
            - "env"  = "dev"
          } -> null
        - tags_all               = {
            - "Name" = "terra-sg"
            - "env"  = "dev"
          } -> null
        - vpc_id                 = "vpc-0284dbf61e6bb3c4b" -> null
      }
  
    # module.vpc.aws_subnet.terra_pub[0] will be destroyed
    - resource "aws_subnet" "terra_pub" {
        - arn                                            = "arn:aws:ec2:ap-south-1:292969846548:subnet/subnet-058f1b3650cbd5ccc" -> null
        - assign_ipv6_address_on_creation                = false -> null
        - availability_zone                              = "ap-south-1a" -> null
        - availability_zone_id                           = "aps1-az1" -> null
        - cidr_block                                     = "10.0.101.0/24" -> null
        - enable_dns64                                   = false -> null
        - enable_lni_at_device_index                     = 0 -> null
        - enable_resource_name_dns_a_record_on_launch    = false -> null
        - enable_resource_name_dns_aaaa_record_on_launch = false -> null
        - id                                             = "subnet-058f1b3650cbd5ccc" -> null
        - ipv6_native                                    = false -> null
        - map_customer_owned_ip_on_launch                = false -> null
        - map_public_ip_on_launch                        = true -> null
        - owner_id                                       = "292969846548" -> null
        - private_dns_hostname_type_on_launch            = "ip-name" -> null
        - tags                                           = {
            - "Name" = "terra-pub1"
            - "env"  = "dev"
          } -> null
        - tags_all                                       = {
            - "Name" = "terra-pub1"
            - "env"  = "dev"
          } -> null
        - vpc_id                                         = "vpc-0284dbf61e6bb3c4b" -> null
      }
  
    # module.vpc.aws_subnet.terra_pub[1] will be destroyed
    - resource "aws_subnet" "terra_pub" {
        - arn                                            = "arn:aws:ec2:ap-south-1:292969846548:subnet/subnet-07a523b421c4a5e6f" -> null
        - assign_ipv6_address_on_creation                = false -> null
        - availability_zone                              = "ap-south-1b" -> null
        - availability_zone_id                           = "aps1-az3" -> null
        - cidr_block                                     = "10.0.102.0/24" -> null
        - enable_dns64                                   = false -> null
        - enable_lni_at_device_index                     = 0 -> null
        - enable_resource_name_dns_a_record_on_launch    = false -> null
        - enable_resource_name_dns_aaaa_record_on_launch = false -> null
        - id                                             = "subnet-07a523b421c4a5e6f" -> null
        - ipv6_native                                    = false -> null
        - map_customer_owned_ip_on_launch                = false -> null
        - map_public_ip_on_launch                        = true -> null
        - owner_id                                       = "292969846548" -> null
        - private_dns_hostname_type_on_launch            = "ip-name" -> null
        - tags                                           = {
            - "Name" = "terra-pub2"
            - "env"  = "dev"
          } -> null
        - tags_all                                       = {
            - "Name" = "terra-pub2"
            - "env"  = "dev"
          } -> null
        - vpc_id                                         = "vpc-0284dbf61e6bb3c4b" -> null
      }
  
    # module.vpc.aws_vpc.terra_vpc will be destroyed
    - resource "aws_vpc" "terra_vpc" {
        - arn                                  = "arn:aws:ec2:ap-south-1:292969846548:vpc/vpc-0284dbf61e6bb3c4b" -> null
        - assign_generated_ipv6_cidr_block     = false -> null
        - cidr_block                           = "10.0.0.0/16" -> null
        - default_network_acl_id               = "acl-08d58a68fed8a1035" -> null
        - default_route_table_id               = "rtb-0622f2cd670da4ec2" -> null
        - default_security_group_id            = "sg-01a51af6dcdaa3581" -> null
        - dhcp_options_id                      = "dopt-08c73d7e63640991d" -> null
        - enable_dns_hostnames                 = true -> null
        - enable_dns_support                   = true -> null
        - enable_network_address_usage_metrics = false -> null
        - id                                   = "vpc-0284dbf61e6bb3c4b" -> null
        - instance_tenancy                     = "default" -> null
        - ipv6_netmask_length                  = 0 -> null
        - main_route_table_id                  = "rtb-0622f2cd670da4ec2" -> null
        - owner_id                             = "292969846548" -> null
        - tags                                 = {
            - "Name" = "terra-vpc"
            - "env"  = "dev"
          } -> null
        - tags_all                             = {
            - "Name" = "terra-vpc"
            - "env"  = "dev"
          } -> null
      }
  
  Plan: 0 to add, 0 to change, 17 to destroy.
  module.iam-roles-policies.aws_iam_role_policy_attachment.policy_AmazonEKSVPCResourceController: Destroying... [id=eksClusterRole-20231117061041306900000001]
  module.iam-roles-policies.aws_iam_role_policy_attachment.policy_AmazonEKS_CNI_Policy: Destroying... [id=eksNodeGroupRole-20231117061042200300000004]
  module.iam-roles-policies.aws_iam_role_policy_attachment.policy_AmazonEKSClusterPolicy: Destroying... [id=eksClusterRole-20231117061041342000000002]
  module.route-table.aws_route_table_association.terra_rtb_a[1]: Destroying... [id=rtbassoc-0c07b2ec6e774b293]
  module.iam-roles-policies.aws_iam_role_policy_attachment.policy_AmazonEC2ContainerRegistryReadOnly: Destroying... [id=eksNodeGroupRole-20231117061042273800000005]
  module.iam-roles-policies.aws_iam_role_policy_attachment.policy_AmazonEKSWorkerNodePolicy: Destroying... [id=eksNodeGroupRole-20231117061042026900000003]
  module.route-table.aws_route_table_association.terra_rtb_a[0]: Destroying... [id=rtbassoc-026a8907efec121f7]
  module.eks.aws_eks_node_group.terra_eks_node: Destroying... [id=terra-eks-cluster:terra-eks-node-group]
  module.route-table.aws_route_table_association.terra_rtb_a[0]: Destruction complete after 1s
  module.route-table.aws_route_table_association.terra_rtb_a[1]: Destruction complete after 1s
  module.route-table.aws_default_route_table.terra_rtb: Destroying... [id=rtb-0622f2cd670da4ec2]
  module.route-table.aws_default_route_table.terra_rtb: Destruction complete after 0s
  module.igw.aws_internet_gateway.terra_igw: Destroying... [id=igw-0ce58418740d771fa]
  module.iam-roles-policies.aws_iam_role_policy_attachment.policy_AmazonEC2ContainerRegistryReadOnly: Destruction complete after 2s
  module.iam-roles-policies.aws_iam_role_policy_attachment.policy_AmazonEKSVPCResourceController: Destruction complete after 2s
  module.iam-roles-policies.aws_iam_role_policy_attachment.policy_AmazonEKSWorkerNodePolicy: Destruction complete after 2s
  module.iam-roles-policies.aws_iam_role_policy_attachment.policy_AmazonEKS_CNI_Policy: Destruction complete after 2s
  module.iam-roles-policies.aws_iam_role_policy_attachment.policy_AmazonEKSClusterPolicy: Destruction complete after 2s
  module.eks.aws_eks_node_group.terra_eks_node: Still destroying... [id=terra-eks-cluster:terra-eks-node-group, 10s elapsed]
  module.igw.aws_internet_gateway.terra_igw: Still destroying... [id=igw-0ce58418740d771fa, 10s elapsed]
  module.eks.aws_eks_node_group.terra_eks_node: Still destroying... [id=terra-eks-cluster:terra-eks-node-group, 20s elapsed]
  module.igw.aws_internet_gateway.terra_igw: Still destroying... [id=igw-0ce58418740d771fa, 20s elapsed]
  module.igw.aws_internet_gateway.terra_igw: Still destroying... [id=igw-0ce58418740d771fa, 5m30s elapsed]
  module.igw.aws_internet_gateway.terra_igw: Destruction complete after 5m36s
  module.eks.aws_eks_node_group.terra_eks_node: Still destroying... [id=terra-eks-cluster:terra-eks-node-group, 5m40s elapsed]
  module.eks.aws_eks_node_group.terra_eks_node: Still destroying... [id=terra-eks-cluster:terra-eks-node-group, 6m30s elapsed]
  module.eks.aws_eks_node_group.terra_eks_node: Destruction complete after 6m32s
  module.iam-roles-policies.aws_iam_role.eks_node_group_role: Destroying... [id=eksNodeGroupRole]
  module.eks.aws_eks_cluster.terra_eks: Destroying... [id=terra-eks-cluster]
  module.iam-roles-policies.aws_iam_role.eks_node_group_role: Destruction complete after 2s
  module.eks.aws_eks_cluster.terra_eks: Still destroying... [id=terra-eks-cluster, 10s elapsed]
  module.eks.aws_eks_cluster.terra_eks: Still destroying... [id=terra-eks-cluster, 1m0s elapsed]
  module.eks.aws_eks_cluster.terra_eks: Destruction complete after 1m9s
  module.iam-roles-policies.aws_iam_role.eks_cluster_role: Destroying... [id=eksClusterRole]
  module.vpc.aws_subnet.terra_pub[1]: Destroying... [id=subnet-07a523b421c4a5e6f]
  module.vpc.aws_subnet.terra_pub[0]: Destroying... [id=subnet-058f1b3650cbd5ccc]
  module.security-group.aws_security_group.terra_sg: Destroying... [id=sg-04e830d3534906b05]
  module.vpc.aws_subnet.terra_pub[1]: Destruction complete after 1s
  module.security-group.aws_security_group.terra_sg: Destruction complete after 1s
  module.vpc.aws_subnet.terra_pub[0]: Destruction complete after 1s
  module.vpc.aws_vpc.terra_vpc: Destroying... [id=vpc-0284dbf61e6bb3c4b]
  module.vpc.aws_vpc.terra_vpc: Destruction complete after 1s
  module.iam-roles-policies.aws_iam_role.eks_cluster_role: Destruction complete after 2s
  
  Destroy complete! Resources: 17 destroyed.
  ```
  
  

**5.3 Infrastructure Provisioning Testing**

- **Steps:**
  - Apply and Destroy Terraform scripts multiple times.
- **Expected Outcome:**
  - Idempotent behavior: No changes on subsequent applies.
- **Acceptance Criteria:**
  - Multiple applies and destroy do not result in infrastructure changes.
  
  
  
  
  
  <img width="960" alt="terraform-re-apply-platform" src="https://github.com/chaitanya-pandeswara/online-boutique-platform-terraform/assets/57262203/e0369dc3-f161-482e-86b6-909dc970a87e">
  
  
  
  
  
  
  
   <img width="599" alt="terraform-re-destroy-platform" src="https://github.com/chaitanya-pandeswara/online-boutique-platform-terraform/assets/57262203/14070163-7913-483d-be72-03cd08278fd4">
  
  

**5.4 Configuration Validation**

- **Steps:**
  - Review and validate VPC, security group, IAM, and EKS configurations.
- **Expected Outcome:**
  - Configurations meet security and compliance requirements.
- **Acceptance Criteria:**
  - No security vulnerabilities identified.
  - IAM roles have the principle of least privilege.

**5.5 EKS Cluster Testing**

- **Steps:**
  - Deploy a sample application to the EKS cluster.
  
- **Expected Outcome:**
  - Application is deployed and accessible.
  
- **Acceptance Criteria:**
  - Application pods are running. 
  
    
  
    
  
    
  
    
  
  <img width="917" alt="cluster-access" src="https://github.com/chaitanya-pandeswara/online-boutique-platform-terraform/assets/57262203/56b46215-a3ca-4b11-8110-9b6089ae39c0">
  
  
  
  <img width="707" alt="kubernetes-service-access" src="https://github.com/chaitanya-pandeswara/online-boutique-platform-terraform/assets/57262203/f377cd63-0f03-4499-9b48-5219cb609629">



**5.6 CI/CD Pipeline Testing**

- **Steps:**
  - Trigger the CI/CD pipeline for creating platform.
  - Trigger the CI/CD pipeline for destroying platform.
  
- **Expected Outcome:**
  - Automated deployment without errors.
  
- **Acceptance Criteria:**
  - CI/CD pipelines completes successfully.
  
    
  
    
  
    
  
    
  
  <img width="940" alt="jenkins-job-status" src="https://github.com/chaitanya-pandeswara/online-boutique-platform-terraform/assets/57262203/665367d4-61a8-481a-8f53-3bc7b5afb9e0">
  
  ​		
  
  ​		<img width="798" alt="jenkins-destroy-job-status" src="https://github.com/chaitanya-pandeswara/online-boutique-platform-terraform/assets/57262203/de1fec94-7c37-472a-b611-d0994a80d29c">
  
  

 

**6. Conclusion**

This design document provides a comprehensive overview of the AWS platform deployment using Terraform. It outlines the architecture, component configurations, security considerations, and deployment process.

