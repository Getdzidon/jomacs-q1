variable "policy_arns" {
  type        = list
  description = "The list of policies arn to add permissions to the IAM role"
}

variable "owner" {
  type        = string
  default     = "Getdzidon"
  description = "The Github repository owner to allow to assume the role"
}

variable "repository" {
  type        = string
  default     = "jomacs-q1"
  description = "The Github repository to allow to assume the role"
}

variable "role_name" {
  type        = string
  default     = "GithubActionsRole"
  description = "Name to assign to the IAM role"
}