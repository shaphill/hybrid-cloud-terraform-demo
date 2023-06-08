user = {
  username = "ADMIN"
  password = "PASSWORD"
  url      = "HOSTNAME"
}

phys-domain = "sp-phys"
tenant      = "sp-lab"
ap          = "lab"
vrf         = "v1"
bd = {
  name = "fabric-bd"
  ip   = "10.0.0.1/24"
}

filter = {
  name  = "ospf-host-filter"
  entry = "ospf-host-entry"
}

contract = {
  name    = "ospf-host-contract"
  subject = "ospf-host-filter"
}

l3out = {
  name      = "l3-ospf"
  domain    = "sp-l3"
  encap     = "vlan-107"
  epg       = "l3-ospf-epg"
  path      = "topology/pod-1/protpaths-103-104/pathep-[sp-vpc]"
  node_prof = "l3-ospf_nodeProfile"
  int_prof  = "l3-ospf_vpcIpv4"
}

ext_subs = ["0.0.0.0/0", "10.0.1.0/24"]

nodes = {
  "103" = {
    name   = "topology/pod-1/node-103"
    rtr_id = "103.103.103.103"
  }
  "104" = {
    name   = "topology/pod-1/node-104"
    rtr_id = "104.104.104.104"
  }
}

vpc_members = {
  "1" = {
    side = "A"
    addr = "10.0.1.2/24"
  }
  "2" = {
    side = "B"
    addr = "10.0.1.3/24"
  }
}

static_path = {
  path  = "topology/pod-1/protpaths-101-102/pathep-[sp-vpc]"
  encap = "vlan-106"
}
