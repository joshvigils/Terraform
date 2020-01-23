variable "loc" {
    description = "Default Azure region"
    default     =   "westeurope"
}

variable "tags" {
    default     = {
        source  = "citadel"
        env     = "training"
    }
}
variable "webappslocs" {
  type    = "list"
  default = ["eastus", "centralus", "westus", "westeurope", "northeurope"]
}
