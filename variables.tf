variable "resource_group_location" {
  type        = string
  default     = "southeastasia"
  description = "Location of the resource group."
}

variable "resource_group_name_prefix" {
  type        = string
  default     = "rg"
  description = "Prefix of the resource group name that's combined with a random ID so name is unique in your Azure subscription."
}

variable "admin_username" {
  type        = string
  description = "The admin username for the Windows node pool."
  default     = "azureuser"
}

variable "admin_password" {
  type        = string
  description = "The admin password for the Windows node pool."
  default     = "Passw0rd1234Us!"
}