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

variable "ecs_cluster_name" {
  type        = string
  description = "Name of ECS Cluster"
}

variable "ecs_task_family" {
  type        = string
  description = "Name of Task Family Profile"
}

variable "ecs_service_name" {
  type        = string
  description = "Name of ECS Service"
}

