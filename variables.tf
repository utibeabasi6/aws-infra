variable "aws_region" {
  default = "us-east-1"
  description = "The region to deploy the resources to"
  type = string
}

variable "vpc_cider" {
    type = string
    description = "(The Cider block to use when setting up the VPC"
    default = "10.0.0.0/16"
}

variable "public_subnet_ciders" {
    type = list(string)
    description = "The subnet ciders for the public subnet"
    default = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_ciders" {
    type = list(string)
    description = "The subnet ciders for the private subnet"
    default = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "database_subnet_ciders" {
    type = list(string)
    description = "The subnet ciders for the database subnet"
    default = ["10.0.7.0/24", "10.0.8.0/24", "10.0.9.0/24"]
}

variable "aws_azs" {
    type = list(string)
    description = "List of availability zones to deploy resources into"
    default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "aws_instance_count" {
    type = number
    description = "The number of LAMP servers to create"
    default = 1
}

variable "aws_instance_ami" {
    type = string
    description = "The AMI of the AWS instance"
    default = "ami-0a8b4cd432b1c3063"
}

variable "aws_instance_type" {
    type = string
    description = "The type of instance to create"
    default = "t2.micro"
}

variable "elasticache_cluster_id" {
    type = string
    description = "The name of your elasticache cluster"
    default = "elasticache-cluster"
}

variable "elasticache_cluster_node_type" {
    type = string
    description = "The node type for the elasticache cluster"
    default = "cache.m4.large"
}

variable "elasticache_num_cache_nodes" {
    type = number
    default = 2
}

variable "rds_db_name" {
    type = string
    description = "The name of your database"
    default = "mydb"
}

variable "rds_username" {
    type = string
    description = "The default username"
    default = "foo"
}

variable "rds_password" {
    type = string
    description = "The default password"
    default = "123456789"
}

variable "rds_cluster_identifier" {
    type = string
    description = "The name of your cluster"
    default = "aurora-cluster-demo"
}

variable "rds_backup_retention" {
    type = number
    description = "How long it should hold a backup"
    default = 0
}

