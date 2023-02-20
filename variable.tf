variable "availability_zone" {
  default = ["ap-south-1a"]
}

variable "vpc_vpc_cidr" {
  default = "10.0.0.0/16"
 }

variable "testpublic" {
  default = "10.0.1.0/24"
  }

variable "testprivate" {
  default = "10.0.2.0/24"
  }
