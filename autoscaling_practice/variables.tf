variable "access_key" {
  type      = string
  sensitive = "true"
}

variable "secret_key" {
  type      = string
  sensitive = "true"
}

variable "region" {
  type      = string
  default   = "us-east-1"
  sensitive = "false"
}

variable "instance"{
 type= string
 sensitive = "false"
}

variable "ami_id"{
 type= string
 sensitive = "false"
}

variable "vpc_cidr"{
 type = string
}

variable "sub1_cidr"{
 type = string 
}

variable "sub2_cidr"{
 type = string
}

variable "scalegp_dc"{
 type = number
}
variable "scalegp_maxsize"{
 type = number
}
variable "scalegp_minsize"{
 type = number
}

