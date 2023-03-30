# Terraform with Cisco ACI Demo
This Terraform configuration creates a tenant, VRF, bridge domain, application profile, EPG, L3Out, and contract to enable communication between a host and endpoint across an ACI fabric.
 
![Topology](imgs/topology.png)
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
