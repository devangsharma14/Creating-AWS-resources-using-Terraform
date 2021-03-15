resource "aws_vpc" "my_app" {
	cidr_block       = "10.0.0.0/16"
    instance_tenancy = "default"

    tags = {
      Name = "Avis"
    }
}