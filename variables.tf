variable "profile" {
  description = "Profile name for AWS provider authentication."
  type        = string
}

variable "region" {
  description = "Default region for AWS provider."
  type        = string
}

variable "lab_solution_url" {
  description = "URL to the lab solution archive."
  type        = string
}

variable "lab_solution_username" {
  description = "Username to access the lab solution archive."
  type        = string
}

variable "lab_solution_password" {
  description = "Password to access the lab solution archive."
  type        = string
}

variable "enable_registry" {
  description = "Whether or not to automatically configure a local registry (Lab 3.2)"
  type        = bool
  default     = false
}