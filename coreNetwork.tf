resource "azurerm_resource_group" "core" {
   name         = "core"
   location     = "${var.loc}"
   tags         = "${var.tags}"
}
resource "azurerm_virtual_network" "core" {
	name					= "core"
	resource_group_name		= "${azurerm_resource_group.core.name}"
	location				= "${azurerm_resource_group.core.location}"
	tags					= "${azurerm_resource_group.core.tags}"
	address_space			= ["10.0.0.0/16"]
	dns_servers				= ["1.1.1.1","1.0.0.1"]
	
	subnet {
	name				= "training"
	address_prefix		= "10.0.1.0/24"
	}

	subnet {
	name				= "dev"
	address_prefix		= "10.0.2.0/24"
	}
}

resource "azurerm_subnet" "GatewaySubnet"  {
	name					= "GatewaySubnet"
	resource_group_name		= "${azurerm_resource_group.core.name}"
	virtual_network_name 	= "${azurerm_virtual_network.core.name}"
	address_prefix			= "10.0.0.0/24"
	}

resource "azurerm_public_ip" "vpnGatewayPublicIp" {
	name				= "vpnGatewayPublicIp"
	location			= "${azurerm_resource_group.core.location}"
	resource_group_name	= "${azurerm_resource_group.core.name}"

	allocation_method 	= "Dynamic"
}

/*resource "azurerm_virtual_network_gateway" "vpnGateway" {
	name				= "vpnGateway"
	location			= "${azurerm_resource_group.core.location}"
	resource_group_name = "${azurerm_resource_group.core.name}"

	type				= "Vpn" 
	vpn_type			= "routebased"

	active_active		= false
	enable_bgp			= false
	sku					= "basic"

	ip_configuration {
	name							= "VnetGatewayConfig1"
	public_ip_address_id			= "${azurerm_public_ip.vpnGatewayPublicIp.id}"
	private_ip_address_allocation	= "dynamic"
	subnet_id						= "${azurerm_subnet.GatewaySubnet.id}"
	}
} */

