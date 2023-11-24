terraform {
  required_version = "~> 1.5"
  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.7"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.4"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2"
    }
  }
}