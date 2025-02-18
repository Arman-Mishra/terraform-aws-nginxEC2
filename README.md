# terraform-aws-nginxEC2

AWS_MODULE for deploying EC2 instance

Terraform module to provision an EC2 instance that is running NGINX

NOT FOR PRODUCTION USE.
FOR DEMONSTRATION PURPOSE

```hcl
terraform {

}

provider "aws" {
  # Configuration options
  region = "region_thats_configured"
}


module "aws_nginx_server" {
  source        = "./terraform-aws-nginxEC2"
  vpc_id        = "vpc-id"
  my_ip_address = "X.X.X.X"
  public_key    = "ssh-rsa KEY"
}

output "instance_public_id" {
  value = module.aws_nginx_server.instance_public_id_1
}

output "aws_ami_name" {
  value = module.aws_nginx_server.ubuntu_ami_id
}

```
