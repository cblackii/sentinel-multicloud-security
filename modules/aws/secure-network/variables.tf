variable "name" {
  description = "Name prefix for the AWS secure network."
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the AWS VPC."
  type        = string
}

variable "availability_zones" {
  description = "Availability Zones used by the network."
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets."
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags applied to supported AWS networking resources."
  type        = map(string)
  default     = {}
}
