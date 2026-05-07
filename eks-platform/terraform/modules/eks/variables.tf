variable "cluster_name" {
  type = string
}

variable "environment" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "eks_version" {
  default = "1.30"
}
