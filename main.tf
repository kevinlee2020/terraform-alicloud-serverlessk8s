#Terraform Provider
provider "alicloud" {
  access_key = "your_access_key"
  secret_key = "your_secret_key"
  region     = "cn-shanghai"

}

variable "name" {
  default = "es-first-k8s"
}

data "alicloud_zones" "default" {
  available_resource_creation = "VSwitch"
}

resource "alicloud_vpc" "default" {
  name       = var.name
  cidr_block = "10.1.0.0/21"
}

resource "alicloud_vswitch" "default" {
  name              = var.name
  vpc_id            = alicloud_vpc.default.id
  cidr_block        = "10.1.1.0/24"
  availability_zone = data.alicloud_zones.default.zones[0].id
}

# alicloud_cs_serverless_kubernetes and serverless
resource "alicloud_cs_serverless_kubernetes" "serverless" {
  name_prefix                    = var.name
  vpc_id                         = alicloud_vpc.default.id
  vswitch_id                     = alicloud_vswitch.default.id

  new_nat_gateway = true
  endpoint_public_access_enabled = true
  private_zone = false
  deletion_protection = false

}
