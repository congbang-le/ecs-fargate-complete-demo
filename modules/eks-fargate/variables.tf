variable "region" {
  default = "Region to deploy the resources"
  type    = string
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default = {
    ManagedBy   = "Terraform"
    Environment = "production"
  }
}

variable "vpc_cidrs" {
  description = "CIDR of VPC"
  type        = string
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for subnets"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for subnets"
  type        = list(string)
}

variable "cluster_name" {
  type        = string
  description = "Name of EKS Cluster"
}

variable "fargate_profile_name" {
  type        = string
  description = "Name of Fargate Profile"
}

