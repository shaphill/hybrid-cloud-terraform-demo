terraform {
  required_providers {
    aci = {
      source = "CiscoDevNet/aci"
    }
  }
}

data "aci_l3_domain_profile" "domain" {
  name = var.l3domain
}

resource "aci_l3_outside" "l3out" {
  tenant_dn                    = var.tenant_id
  name                         = var.l3out
  relation_l3ext_rs_ectx       = var.vrf_id
  relation_l3ext_rs_l3_dom_att = data.aci_l3_domain_profile.domain.id
}

resource "aci_external_network_instance_profile" "l3epg" {
  l3_outside_dn       = aci_l3_outside.l3out.id
  name                = var.l3epg
  relation_fv_rs_cons = [var.contract_id]
}

resource "aci_l3_ext_subnet" "subnet" {
  for_each = var.ext_subnets

  external_network_instance_profile_dn = aci_external_network_instance_profile.l3epg.id
  ip                                   = each.value
}

resource "aci_l3out_ospf_external_policy" "ospf" {
  l3_outside_dn = aci_l3_outside.l3out.id
  area_id       = "0"
  area_type     = "regular"
}

resource "aci_logical_node_profile" "node_profile" {
  l3_outside_dn = aci_l3_outside.l3out.id
  name          = var.node_profile
}

resource "aci_logical_interface_profile" "interface_profile" {
  logical_node_profile_dn = aci_logical_node_profile.node_profile.id
  name                    = var.interface_profile
}

resource "aci_l3out_ospf_interface_profile" "ospf_interface_profile" {
  logical_interface_profile_dn = aci_logical_interface_profile.interface_profile.id
  relation_ospf_rs_if_pol      = aci_l3out_ospf_external_policy.ospf.id
}

resource "aci_logical_node_to_fabric_node" "logic_to_fabric" {
  for_each = var.nodes

  logical_node_profile_dn = aci_logical_node_profile.node_profile.id
  tdn                     = each.value.name
  rtr_id                  = each.value.rtr_id
  rtr_id_loop_back        = "yes"
}

resource "aci_l3out_path_attachment" "l3path" {
  logical_interface_profile_dn = aci_logical_interface_profile.interface_profile.id
  target_dn                    = var.l3path
  if_inst_t                    = "ext-svi"
  addr                         = "0.0.0.0"
  encap                        = var.encap
  mtu                          = "1500"
}

resource "aci_l3out_vpc_member" "vpc_member" {
  for_each = var.vpc_members

  leaf_port_dn = aci_l3out_path_attachment.l3path.id
  side         = each.value.side
  addr         = each.value.addr
}
