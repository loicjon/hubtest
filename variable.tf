#######################################################################################################
############################################ Variables ################################################
#######################################################################################################


variable "resource_group_location" {

  type        = string
  description = "location"

}

variable "tags" {

  type        = map(any)
  description = "Ressource tags"

}

variable "resource_group_name" {

  type        = string
  description = "resource group name"

}


# Variable pour le ressource groupe 

variable "resource_group_name_spoke1" {

  type        = string
  description = "resource group name of spoke 1"

}


variable "storage_account_name" {

  type        = string
  description = "Storage account name"

}


variable "service_plan_name" {

  type        = string
  description = "Service Plan name"

}

variable "windows_function_app_name" {

  type        = string
  description = "Function App name"

}

variable "windows_web_app_name" {

  type        = string
  description = "Web App name"

}

variable "sql_server_name" {

  type        = string
  description = "sql server name"

}

variable "sql_database_name" {

  type        = string
  description = "sql server name"

}

variable "login" {

  type        = string
  description = "sql server login"

}

variable "password" {

  type        = string
  description = "sql server password"

}

variable "virtual_network_name_spoke" {

  type        = string
  description = "virtual network name"

}

variable "virtual_network_name" {

  type        = string
  description = "virtual network name"

}

variable "virtual_network_address" {

  type        = list(any)
  description = "virtual network address"

}


variable "subnet_name" {

  type        = string
  description = "subnet name"

}

variable "subnet_address" {

  type        = list(any)
  description = "subnet address"

}

variable "hub_address_space" {

  type        = list(any)
  description = "La plage d'adresse du réseau virtuel en classe A"

}