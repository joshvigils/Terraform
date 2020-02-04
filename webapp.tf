provider "random" {
}

resource "azurerm_resource_group" "webapps" {
	name		= "webapps"
	location	= var.loc
	tags		= var.tags
}
resource "random_string" "webapprnd" {
  length  = 8
  lower   = true
  number  = true
  upper   = false
  special = false
}
resource "azurerm_app_service_plan" "free" {
	count				= "${length(var.webappslocs)}"
    name                = "plan-free-${var.webappslocs[count.index]}"
    location            = "${var.webappslocs[count.index]}"
    resource_group_name = "${azurerm_resource_group.webapps.name}"
    tags                = "${azurerm_resource_group.webapps.tags}"

    kind                = "Windows"
    reserved            = true
    sku {
        tier = "Standard"
        size = "S1"
    }
}
locals {
  webappsperloc = 3
}

resource "azurerm_app_service" "citadel" {
	count               = "${length(var.webappslocs) * local.webappsperloc}"
    name                = "${format("webapp-%s-%02d-%s", random_string.webapprnd.result, count.index + 1, element(var.webappslocs, count.index))}"
    location            = "${element(var.webappslocs, count.index)}"
    resource_group_name = "${azurerm_resource_group.webapps.name}"
    tags                = "${azurerm_resource_group.webapps.tags}"

    app_service_plan_id = "${element(azurerm_app_service_plan.free.*.id, count.index)}"
}



