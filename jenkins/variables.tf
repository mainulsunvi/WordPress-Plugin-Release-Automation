variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "aws_access_key" {
  type      = string
  sensitive = true
  default   = "AKIAQGDWYYR45JDVS6E7"
}

variable "aws_secret_key" {
  type      = string
  sensitive = true
  default   = "GzlysEgTDjvnVY+47BnGngJObazcDfUhzepoaxqm"
}