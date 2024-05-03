variable "registry_name" {
  type        = string
  default     = "my-registry"
  description = "name of ecr repository"
}

variable "is_mutable" {
  type        = bool
  default     = true
  description = "sets tags immutability"
}

variable "enable_scanning" {
  type        = bool
  default     = true
  description = "sets scanning of images on push"
}

variable "encryption_type" {
  type        = string
  default     = "KMS"
  description = "either KMS or AES256"
}

variable "registry_tags" {
  type = map(string)
  default = {
    "name" = "my-registry"
  }
  description = "tags to be applied to repository"
}