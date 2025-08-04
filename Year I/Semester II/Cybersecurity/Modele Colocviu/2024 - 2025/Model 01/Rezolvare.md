# Solution

## I) Standard configuration

### R1

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
interface gigabitEthernet0/0
no shutdown
ip address 18.10.1.33 255.255.255.252
description "legatura cu R2"
interface gigabitEthernet0/1
no shutdown
ip address 18.10.1.37 255.255.255.252
description "legatura cu R4"
router ospf 1
network 18.10.1.32 0.0.0.3 area 1
network 18.10.1.36 0.0.0.3 area 1
do write
```

## II) + III) IP configuration + dynamic routing

### R2

```
enable
configure terminal
interface fastEthernet 0/1
no shutdown
ip address 15.16.1.65 255.255.255.252
interface fastEthernet 0/0
no shutdown
ip address 15.16.1.69 255.255.255.252
interface ethernet 0/0/0
ip address 18.10.1.34 255.255.255.252
no shutdown
interface ethernet 0/1/0
ip address 18.10.1.41 255.255.255.252
no shutdown
router rip
version 2
no auto-summary
network 15.16.1.64
redistribute ospf 1 metric 1
router ospf 1
network 18.10.1.32 0.0.0.3 area 1
network 18.10.1.40 0.0.0.3 area 1
redistribute rip metric 200 subnets
do write
```

### R3

```
enable
configure terminal
interface gigabitEthernet 0/0
no shutdown
ip address 18.10.1.45 255.255.255.252
interface gigabitEthernet 0/1
no shutdown
ip address 18.10.1.42 255.255.255.252
interface gigabitEthernet 0/2
no shutdown
ip address 18.10.1.49 255.255.255.252
router ospf 1
network 18.10.1.40 0.0.0.3 area 1
network 18.10.1.44 0.0.0.3 area 1
network 18.10.1.48 0.0.0.3 area 1
do write
```

### R4

```
enable
configure terminal
interface fastEthernet 0/1
no shutdown
ip address 11.0.1.1 255.255.255.252
interface fastEthernet 0/0
no shutdown
ip address 11.0.1.5 255.255.255.252
interface ethernet 0/0/0
ip address 18.10.1.38 255.255.255.252
no shutdown
interface ethernet 0/1/0
ip address 18.10.1.46 255.255.255.252
no shutdown
router ospf 1
network 18.10.1.36 0.0.0.3 area 1
network 18.10.1.44 0.0.0.3 area 1
redistribute eigrp 1 metric 100 subnets
router eigrp 1
no auto-summary
network 11.0.1.0 0.0.0.3
network 11.0.1.4 0.0.0.3
redistribute ospf 1 metric 10000 100 255 1 1500
do write
```

### R5

```
enable
configure terminal
interface gigabitEthernet 0/0
no shutdown
ip address 11.0.1.2 255.255.255.252
interface gigabitEthernet 0/1
no shutdown
ip address 11.0.1.9 255.255.255.252
interface gigabitEthernet 0/2
no shutdown
ip address 11.0.1.17 255.255.255.252
router eigrp 1
no auto-summary
network 11.0.1.0 0.0.0.3
network 11.0.1.8 0.0.0.3
network 11.0.1.16 0.0.0.3
do write
```

### R6

```
enable
configure terminal
interface gigabitEthernet 0/0
no shutdown
ip address 11.0.1.6 255.255.255.252
interface gigabitEthernet 0/1
no shutdown
ip address 11.0.1.13 255.255.255.252
interface gigabitEthernet 0/2
no shutdown
ip address 11.0.1.21 255.255.255.252
router eigrp 1
no auto-summary
network 11.0.1.4 0.0.0.3
network 11.0.1.12 0.0.0.3
network 11.0.1.20 0.0.0.3
do write
```

### R7

```
enable
configure terminal
interface gigabitEthernet 0/0
no shutdown
ip address 11.0.1.14 255.255.255.252
interface gigabitEthernet 0/1
no shutdown
ip address 11.0.1.10 255.255.255.252
router eigrp 1
no auto-summary
network 11.0.1.8 0.0.0.3
network 11.0.1.12 0.0.0.3
do write
```

### R8

```
enable
configure terminal
interface gigabitEthernet 0/0
no shutdown
ip address 15.16.1.73 255.255.255.252
interface gigabitEthernet 0/1
no shutdown
ip address 15.16.1.66 255.255.255.252
interface gigabitEthernet 0/2
no shutdown
ip address 15.16.1.81 255.255.255.252
router rip
version 2
no auto-summary
network 15.16.1.64
do write
```

### R9

```
enable
configure terminal
interface gigabitEthernet 0/0
no shutdown
ip address 15.16.1.89 255.255.255.252
interface gigabitEthernet 0/1
no shutdown
ip address 15.16.1.77 255.255.255.252
interface gigabitEthernet 0/2
no shutdown
ip address 15.16.1.70 255.255.255.252
router rip
version 2
no auto-summary
network 15.16.1.64
do write
```

### R10

```
enable
configure terminal
interface gigabitEthernet 0/0
no shutdown
ip address 15.16.1.74 255.255.255.252
interface gigabitEthernet 0/1
no shutdown
ip address 15.16.1.78 255.255.255.252
interface gigabitEthernet 0/2
no shutdown
ip address 15.16.1.85 255.255.255.252
router rip
version 2
no auto-summary
network 15.16.1.64
do write
```

## IV) VPN

### R8

```
interface tunnel 0
no shutdown
ip address 84.84.1.1 255.255.255.252
tunnel source gigabitEthernet 0/1
tunnel destination 11.0.1.2
tunnel mode gre ip
ip route 11.0.1.16 255.255.255.252 84.84.1.2
do write
```

### R5

```
interface tunnel 0
no shutdown
ip address 84.84.1.2 255.255.255.252
tunnel source gigabitEthernet 0/0
tunnel destination 15.16.1.66
tunnel mode gre ip
ip route 15.16.1.80 255.255.255.252 84.84.1.1
do write
```

## V) Wireless

## V) ACL

### R10

```
access-list 100 permit tcp host 15.16.1.86 host 11.0.1.22 eq 80
access-list 100 permit tcp host 15.16.1.86 host 11.0.1.22 eq 443
access-list 100 permit ip any any
access-list 101 permit tcp host 11.0.1.18 host 15.16.1.86 eq 22
access-list 101 deny tcp any host 15.16.1.86 eq 22
access-list 101 permit ip any any
interface gigabitEthernet 0/2
ip access-group 100 in
ip access-group 101 out
```

### R6

```
access-list 100 permit tcp host 11.0.1.22 host 15.16.1.86 eq 80
access-list 100 permit tcp host 11.0.1.22 host 15.16.1.86 eq 443
access-list 100 permit ip any any
access-list 101 permit tcp host 11.0.1.18 host 11.0.1.22 eq 22
access-list 101 deny tcp any host 11.0.1.22 eq 22
access-list 101 permit ip any any
interface gigabitEthernet 0/2
ip access-group 100 in
ip access-group 101 out
```

### R9

```
access-list 101 permit tcp host 11.0.1.18 host 15.16.1.90 eq 22
access-list 101 deny tcp any host 15.16.1.90 eq 22
access-list 101 deny ip host 15.16.1.82 15.16.1.88 0.0.0.3
access-list 101 permit ip any any
interface gigabitEthernet 0/0
ip access-group 101 out
```
