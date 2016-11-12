provider "aws" {
  access_key	= "${var.access_key}"
  secret_key	= "${var.secret_key}"
  region 	= "${var.region}"
}

resource "aws_vpc" "default" {
  cidr_block = "172.31.0.0/16"

}

resource "aws_subnet" "main" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "172.31.16.0/20"
  map_public_ip_on_launch = "true"
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.default.id}"
}

resource "aws_instance" "chef" {
  ami = "ami-b63769a1"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.default.id}"]
  key_name = "ubuntu"
  user_data = "${file("user_data.sh")}"
  depends_on = ["aws_internet_gateway.gw", "aws_security_group.default"]
  subnet_id = "${aws_subnet.main.id}"
  tags {
    Name = "chef-rehl"
  }

  provisioner "chef" {
    node_name = "oliveira"
    run_list = ["learn_chef_httpd::default"]
    server_url = "https://api.chef.io/organizations/dgtal"
    user_name = "oliveira"
    user_key = "${file("oliveira.pem")}"
    connection = {
      type = "ssh"
      user = "ec2-user"
      private_key = "${file("rhel.pem")}"
    }
  }
}

resource "aws_security_group" "default" {
  name = "chef-rhel-sg"
  description = "Chef Security Group"
  vpc_id = "${aws_vpc.default.id}"
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
