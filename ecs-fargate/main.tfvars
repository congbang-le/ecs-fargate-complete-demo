region               = "ap-southeast-1"
vpc_cidrs            = "10.0.0.0/16"
private_subnet_cidrs = ["10.0.0.0/19", "10.0.32.0/19"]
public_subnet_cidrs  = ["10.0.64.0/19", "10.0.96.0/19"]
ecs_cluster_name     = "Demo-ECS-Cluster"
ecs_task_family      = "Demo-Task-Definition"
ecs_service_name     = "Demo-ECS-Service"