variable "vpc_id" {
  type = string
}

variable "my_ip_address" {
  type        = string
  description = "Provide your current IPv4 IP address"
}

variable "public_key" {
  type        = string
  description = "Paste your public key for authentication using rsa-ssh"
}

variable "instance_type" {
  type        = string
  description = "Provide the value for the instance size that needs to be deployed in aws"
  default     = "t2.medium"
}

variable "server_name" {
  type        = string
  default     = "EC2_NGINX"
  description = "Provided the name for the EC2 instance that will be populated in the aws console"
}