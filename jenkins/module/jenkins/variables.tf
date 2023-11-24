variable "key_pair_name" {
  type    = string
  default = "awsKey"
}

variable "sg_ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_block  = string
    description = string
  }))
  default = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
      description = "Group Rules for Jenkins Access"
    },
    {
      from_port   = 8000
      to_port     = 8000
      protocol    = "tcp"
      cidr_block  = "0.0.0.0/0"
      description = "Group Rules for Note App Access"
    },
  ]
}