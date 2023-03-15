variable "tenant_id" {}

variable "contract_id" {}

variable "vrf_id" {}

variable "l3domain" {}

variable "l3out" {}

variable "l3epg" {}

variable "l3path" {}

variable "encap" {}

variable "ext_subnets" {
  type = set(string)
}

variable "node_profile" {}

variable "interface_profile" {}

variable "nodes" {
  type = map(object({
    name   = string
    rtr_id = string
  }))
}

variable "vpc_members" {
  type = map(object({
    side = string
    addr = string
  }))
}
