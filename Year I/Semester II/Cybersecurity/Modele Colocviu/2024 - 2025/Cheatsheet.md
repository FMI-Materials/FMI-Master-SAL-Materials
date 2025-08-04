# Cheatsheet

## I) Standard configuration

```
en
conf term
no ip domain-lookup
service password-encryption
security passwords min-length 10
login block-for 120 attempts 3 within 60
enable password cisco54321
enable secret cisco12345
banner login #Accesul persoanelor neautorizate interzis!#
banner motd #Vineri la ora 16 serverul intra in mentenanta!#
line console 0
password ciscoconpass
login
logging synchronous
exec-timeout 0 0
line vty 0 15
password ciscovtypass
login
logging synchronous
exec-timeout 0 0
no cdp run
interface INTERFACE
no shutdown
ip address IP MASK
description "legatura cu X"
```

## II) IP configuration

```
enable
configure terminal
interface INTERFACE
no shutdown
ip address IP MASK
do write
```

## III) Dynamic routing

RIP <-> OSPF

```
router rip
version 2
no auto-summary
network IP
redistribute ospf 1 metric 1
router ospf 1
network IP WILDCARD area 1
redistribute rip metric 200 subnets
do write
```

RIP <-> EIGRP

```
router rip
version 2
no auto-summary
network IP
redistribute eigrp 1 metric 1
router eigrp 1
no auto-summary
network IP
redistribute rip metric 10000 100 255 1 1500
do write
```

OSPF <-> EIGRP

```
router ospf 1
network IP WILDCARD area 1
redistribute eigrp 1 metric 100 subnets
router eigrp 1
no auto-summary
network IP WILDCARD
redistribute ospf 1 metric 10000 100 255 1 1500
do write
```

## IV) VPN

```
interface tunnel 0
no shutdown
ip address IP MASK
tunnel source INTERFACE
tunnel destination IP
tunnel mode gre ip
ip route IP MASK IP
do write
```

## V) Wireless

## V) ACL
