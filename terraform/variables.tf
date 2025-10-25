variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}


variable "project" {
  type    = string
  default = "node-ecs-fargate"
}


variable "vpc_cidr" {
  default = "10.0.0.0/16"
}


variable "public_subnet_cidrs" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}