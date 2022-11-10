include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "git::git@github.com:infracloudio/terraform-aws-eks.git"
}

/* generate ""kmskey"" {
  path = "kmskey.tf"
  if_exists = "overwrite_terragrunt"

  contents = <<EOF
  description             = "EKS Secret Encryption Key"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  //tags = local.tags
EOF
} */

dependency "vpc" {
  config_path = "${get_terragrunt_dir()}/../../networking/vpc"

  mock_outputs = {
    vpc_id                        = "vpc-efgh5678"
    vpc_enable_dns_support        = "fd00:ec2::253"
    vpc_enable_dns_hostnames      = "www.thousandeyes.com"
    private_subnets               = ["subnet-abcd1234", "subnet-bcd1234a", ]
    public_subnets                = ["subnet-abcd12345b", "subnet-bcd12345b", ]
    nat_ids                       = "nat-abcd4321"
    nat_public_ips                = ["192.0.0.0", "192.0.0.1",]
    natgw_ids                     = "natgw-abcd2341"
    igw_id                        = "igw-lmnop4235"
    vpc_flow_log_id               = "vpc"
    vpc_flow_log_destination_arn  = "arn:aws:logs:ap-south-1:919611311137:log-group:/aws/vpc-flow-log/vpc-efgh5678:*"
    vpc_flow_log_destination_type = "cloud-watch-logs"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

inputs = {
    cluster_name                    = "inception-eks-fargate"
    region                          = "us-east-1"
    instance_types                  = ["t3.small"]
    desired_size                    = 1
    cluster_endpoint_public_access  = true
    cluster_endpoint_private_access = true
    control_plane_subnet_ids        = dependency.vpc.outputs.private_subnets
    vpc_id                          = dependency.vpc.outputs.vpc_id
}