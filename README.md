# aci-vpc-project

## ACI Tenant Object Hierarchy
```
Tenant
|__ AP
	|__ EPG
		| Physical Domain
		| Static Ports
		| Provided Contract
|__ Bridge Domain
	| Subnet (public)
	| L3Out
| VRF
|__ L3Out (OSPF)
	|__ Logical Node Profile
		| Logical Interface Profile
	|__ External EPG
		| Consumed Contract
```