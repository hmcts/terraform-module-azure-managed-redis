terraform {
  required_version = ">= 1.2.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.0.0"
    }
  }
  backend "azurerm" {
    # resource_group_name  = "jenkins-state-test"
    # storage_account_name = "sdsstatetest"
    # container_name       = "tfstate-test"
    # key                  = "libragob/test/terraform.tfstate"
    # subscription_id      = "b3394340-6c9f-44ca-aa3e-9ff38bd1f9ac"
  }
}

provider "azurerm" {
  features {}
}
