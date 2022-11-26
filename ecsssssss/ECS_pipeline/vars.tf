variable "repo_name" {
  type    = string
  default = "Dockerpipe1"
}

variable "owner" {
  description = "ThirdParty"
  type = string
  default = "ThirdParty"
}

variable "branch_name" {
  type    = string
  default = "main"
}

variable "build_project" {
  type    = string
  default = "dev-build-repo"
}

variable "build_project2" {
  type    = string
  default = "dev-build-repo2"
}


variable "build_project3" {
  type    = string
  default = "dev-build-repo3"
}


variable "build_project4" {
  type    = string
  default = "dev-build-repo4"
}

variable "build_project5" {
  type    = string
  default = "dev-build-repo5"
}


variable "build_project6" {
  type    = string
  default = "dev-build-repo6"
}

variable "cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "azs" {
  type = list(string)
  default = [
    "us-east-1a",
    "us-east-1b"
  ]
}

variable "subnets-ip" {
  type = list(string)
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]

}