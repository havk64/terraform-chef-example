output "public ip" {
  value = "${aws_instance.chef.public_ip}"
}

output "public dns" {
  value = "${aws_instance.chef.public_dns}"
}
