variable "compartment_id" {
  type        = string
  description = "The target compartment"
}

variable "container_definition" {
  description = "The container definition"
  type = object({
    name  = string,
    image = string,
    shape = object({
      shape  = string,
      ocpus  = number,
      memory = number
    }),
    resource = object({
      vcpus_limit         = number,
      memory_limit_in_gbs = number
    }),
    ports = object({
      port     = number,
      protocol = string
    }),
    volumes = object({
      mount_path  = string,
      volume_name = string,
      size_in_gbs = number
    }),
    health_checks = object({
      type = string,
      port = number
    }),
    environment_variables = map(string)
    command               = list(string)
  })
}

variable "subnet" {
  type        = string
  description = "The target subnet OCID"
}

variable "environment" {
  type        = string
  description = "The target environment"
}

variable "application_name" {
  type = string
  default = "General"
  description = "The application name that will be deployed over this resource"
}