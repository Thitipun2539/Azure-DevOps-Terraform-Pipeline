# Define the Terraform configuration
terraform {
  # Specify the backend to use for storing the Terraform state
  backend "azurerm" {
    # Name of the Azure Resource Group where the storage account resides
    resource_group_name  = "demo-rg"
    
    # Name of the Azure Storage Account to store the Terraform state file
    storage_account_name = "thitistorage"
    
    # Name of the container within the storage account to hold the state file
    container_name       = "thitiblob"
    
    # Key (path) used to store the Terraform state file within the container
    key                  = "prod.terraform.tfstate"
  }
}
