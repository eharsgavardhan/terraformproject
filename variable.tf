#resource.tf
variable "vpc_cidr_block" {
  type = string
  default = "10.0.0.0/16"
}
variable "subnet_cidr_block" {
    type = string
    default = "10.0.0.0/24"
}
variable "public_cidr_block" {
    type = string
    default = "10.0.1.0/24"
}
variable "private_1_subnet_cidr_block" {
    type = string
    default = "10.0.2.0/24"
}
variable "private_2_subnet_cidr_block" {
    type = string
    default = "10.0.2.0/24"
}
variable "db_1_subnet_cidr_block" {
    type = string
    default = "10.0.3.0/24"
}
variable "db_2_subnet_cidr_block" {
    type = string
    default = "10.0.4.0/24"
}
#instance.tf

variable "ami" {
  type = string
  default = "ami-066784287e358dad1"
}
variable "instance_type" {
    type = string
    default = "t2.micro"
  
}
#rds.tf

variable "db_username" {
    type = string
    default = "harsha"
}
variable "db_userpassword" {
    type = string
    default = "harsha@12345"
}
variable "db_subnet_name" {
    default = "project_rds"
}
variable "db_name" {
    default = "test"
}
#auroscaling.tf

  variable "CLIENT_SG_ID" {}
variable "MAX_SIZE" {
    default = 6
}
variable "MIN_SIZE" {
    default = 2
}
variable "DESIRED_CAP" {
    default = 3
}
variable "asg_health_check_type" {
    default = "elb"
    }
variable "target_cloud" {}

