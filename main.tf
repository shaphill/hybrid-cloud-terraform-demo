terraform {
  required_providers {
    aci = {
      source = "CiscoDevNet/aci"
    }
  }
}

provider "aci" {
  username = var.user.username
  password = var.user.password
  url      = var.user.url
  insecure = true
}

data "aci_physical_domain" "phys" {
  name = var.phys-domain
}

resource "aci_tenant" "tenant" {
  name = var.tenant
}

resource "aci_application_profile" "ap" {
  tenant_dn = aci_tenant.tenant.id
  name      = "lab"
}

resource "aci_vrf" "vrf" {
  tenant_dn = aci_tenant.tenant.id
  name      = var.vrf
}

resource "aci_bridge_domain" "bd" {
  tenant_dn                = aci_tenant.tenant.id
  name                     = var.bd.name
  relation_fv_rs_ctx       = aci_vrf.vrf.id
  relation_fv_rs_bd_to_out = [module.l3out.id]
}

resource "aci_subnet" "subnet" {
  parent_dn = aci_bridge_domain.bd.id
  ip        = var.bd.ip
  scope     = ["public"]
}

resource "aci_application_epg" "epg" {
  application_profile_dn = aci_application_profile.ap.id
  name                   = "host"
  relation_fv_rs_bd      = aci_bridge_domain.bd.id
}

resource "aci_epg_to_domain" "epgdom" {
  application_epg_dn = aci_application_epg.epg.id
  tdn                = data.aci_physical_domain.phys.id
}

resource "aci_filter" "filter" {
  tenant_dn = aci_tenant.tenant.id
  name      = var.filter.name
}

resource "aci_filter_entry" "filter_entry" {
  filter_dn = aci_filter.filter.id
  name      = var.filter.entry
}

resource "aci_contract" "contract" {
  tenant_dn = aci_tenant.tenant.id
  name      = var.contract.name
}

resource "aci_contract_subject" "contract_subject" {
  contract_dn                  = aci_contract.contract.id
  name                         = var.contract.subject
  relation_vz_rs_subj_filt_att = [aci_filter.filter.id]
}

resource "aci_epg_to_contract" "epg_contract" {
  application_epg_dn = aci_application_epg.epg.id
  contract_dn        = aci_contract.contract.id
  contract_type      = "provider"
}

resource "aci_epg_to_static_path" "epg_path" {
  application_epg_dn = aci_application_epg.epg.id
  tdn                = var.static_path.path
  encap              = var.static_path.encap
}

module "l3out" {
  source = "./modules/l3out"

  tenant_id         = aci_tenant.tenant.id
  l3domain          = var.l3out.domain
  l3out             = var.l3out.name
  l3epg             = var.l3out.epg
  l3path            = var.l3out.path
  encap             = var.l3out.encap
  ext_subnets       = var.ext_subs
  node_profile      = var.l3out.node_prof
  interface_profile = var.l3out.int_prof
  nodes             = var.nodes
  vpc_members       = var.vpc_members
  contract_id       = aci_contract.contract.id
  vrf_id            = aci_vrf.vrf.id
}


