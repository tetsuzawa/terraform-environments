variable "bucket_name" {
  type = string
  default = "static-site"
}

variable "main_domain_name" {
  type = string
  default = ""
  description = "The Domain which you want to serve the website on (e.g. `example.com`)"
}

variable "sub_domain_name" {
  type = map(string)
  default = {
    "default.name" = ""
  }
}

variable "zone_id" {
  description = "The ID of hosted zone which your domain will be hosted"
}

variable "acm_certificate_arn" {
  type = map(string)
  default = {}
  description = "The Domain of site (e.g. `example.com`)"
}

variable "iam" {
  type = map(string)
  default = {}
}