
# How can you use Terraform to provision an Azure Storage Account, Blob Container, Service Bus Queue, and Event Grid Subscription for blob upload notifications?**


#provider

provider "azurerm" {

     features {}
  
}

# resource group
resource "azurerm_resource_group" "rg" {
  name = "default-rg"
  location = "centralindia"
  
}

#Storage Account: Creates a Standard Storage Account with LRS replication.

resource "azurerm_storage_account" "upload_storage_account" {
  name                     = "uploadstorageaccount0026"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Storage Container: Creates a blob container with public blob access.

resource "azurerm_storage_container" "upload_container" {
  name                  = "upload-container"
  storage_account_id    = azurerm_storage_account.upload_storage_account.id
  container_access_type = "blob"
}

# Service Bus Namespace: Creates a Standard-tier Service Bus namespace.

resource "azurerm_servicebus_namespace" "upload_queue_ns" {
  name                = "upload-queue-ns0026"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "Standard"
}

# Service Bus Queue: Creates a queue with partitioning enabled for better scalability.
resource "azurerm_servicebus_queue" "upload_queue" {
  name         = "upload-queue"
  namespace_id = azurerm_servicebus_namespace.upload_queue_ns.id

  partitioning_enabled = true

}

# Event Grid Subscription: Listens for blob creation events in the storage container and forwards them to the Service Bus queue.
resource "azurerm_eventgrid_event_subscription" "upload_subscription" {
  name  = "upload-event-subscription"

  scope = azurerm_storage_account.upload_storage_account.id

  included_event_types = [
    "Microsoft.Storage.BlobCreated"
  ]

  service_bus_queue_endpoint_id = azurerm_servicebus_queue.upload_queue.id

depends_on = [
    azurerm_storage_container.upload_container,
    azurerm_servicebus_queue.upload_queue
  ]
}




  



