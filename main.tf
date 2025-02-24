//datasource is used as the resource is already present and need not be created only needs to be referenced
data "aws_vpc" "main" {
  id = var.vpc_id
}

data "aws_subnets" "list_of_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }
}

//We need this key in order to ssh into the EC2 instance
resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = var.public_key
}

//The ami is selected for ubuntu
data "aws_ami" "ubuntu" {
  most_recent = true
  owners = ["099720109477"]
     filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }
}


//The same key has been referenced in the below resource definition for the EC2 instance
resource "aws_instance" "vm_1" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  //the full path to the above mentioned keyname
  key_name = aws_key_pair.deployer.key_name
  //attaching the security group
  vpc_security_group_ids = [aws_security_group.sg_vm_1.id]
  //attaching a particular subnet id which is same as the security group subnet id in case of other available subnets
  subnet_id = tolist(data.aws_subnets.list_of_subnets.ids)[0]
  //Bringing and linking in the cloud-init config to install and launch the httpd server
  user_data = data.template_file.user_data.rendered
  tags = {
    Name = var.server_name
  }
}

//NSG to be attached to the EC2 for allowing traffic
resource "aws_security_group" "sg_vm_1" {
  name        = "sg_vm_1"
  description = "My server security group"

  //copying the vpc id from aws account, this is the vpc_id value passed in through the variable
  vpc_id = data.aws_vpc.main.id

  //Ingress rule to allow traffic from port 80(HTTP) from anywhere
  ingress = [
    {
      description      = "HTTP"
      protocol         = "tcp"
      self             = true
      from_port        = 80
      to_port          = 80
      cidr_blocks      = ["0.0.0.0/0"]
      prefix_list_ids  = []
      ipv6_cidr_blocks = []
      security_groups  = []
    },

    //Ingress rule to allow traffic from port 22(SSH) from current ip address which can change over time
    {
      description      = "SSH"
      protocol         = "tcp"
      self             = true
      from_port        = 22
      to_port          = 22
      cidr_blocks      = ["${var.my_ip_address}/32"]
      prefix_list_ids  = []
      ipv6_cidr_blocks = []
      security_groups  = []
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "template_file" "user_data" {
  template = file("${abspath(path.module)}/userdata.yaml")
}