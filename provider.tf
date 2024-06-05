# Specify the Terraform settings, including required providers
terraform {
  # Define the required providers for this configuration
  required_providers {
    # Specify the Azure Resource Manager provider
    azurerm = {
      # Source of the provider, in this case, it's from HashiCorp
      source  = "hashicorp/azurerm"
      # Specify the version of the provider to use
      version = "3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}