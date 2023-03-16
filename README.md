# aci-vpc-project

## ACI Tenant Object Hierarchy
```
Tenant
|_ AP
  |_ EPG
    | Physical Domain
    | Static Ports
    | Provided Contract
|_ Bridge Domain
  | Subnet (public)
  | L3Out
| VRF
|_ L3Out (OSPF)
  |_ Logical Node Profile
    | Logical Interface Profile
  |_ External EPG
    | Consumed Contract
```
