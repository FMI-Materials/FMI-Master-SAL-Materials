# Solution

## I)

### Ex3

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
interface gigabitEthernet 0/0
no shutdown
ip address 80.80.23.13 255.255.255.252
description "legatura cu AdminPC"
interface gigabitEthernet 0/1
no shutdown
ip address 80.80.23.6 255.255.255.252
description "legatura cu Ex1"
interface gigabitEthernet 0/2
no shutdown
ip address 80.80.23.10 255.255.255.252
description "legatura cu Ex2"
router ospf 1
network 80.80.23.4 0.0.0.3 area 1
network 80.80.23.8 0.0.0.3 area 1
network 80.80.23.12 0.0.0.3 area 1
do write
```

## II)

### Ex1

```
enable
configure terminal
interface gigabitEthernet 0/1
no shutdown
ip address 80.80.23.5 255.255.255.252
interface gigabitEthernet 0/0
no shutdown
ip address 80.80.23.1 255.255.255.252
interface serial 0/0/0
no shutdown
ip address 10.0.23.137 255.255.255.252
interface serial 0/0/1
no shutdown
ip address 10.0.23.141 255.255.255.252
router ospf 1
network 80.80.23.4 0.0.0.3 area 1
network 80.80.23.0 0.0.0.3 area 1
redistribute eigrp 1 metric 100 subnets
router eigrp 1
no auto-summary
network 10.0.23.136 0.0.0.3
network 10.0.23.140 0.0.0.3
redistribute ospf 1 metric 10000 100 255 1 1500
do write
```

### RouterD1

```
enable
configure terminal
interface gigabitEthernet 0/0
no shutdown
ip address 10.0.23.149 255.255.255.252
interface serial 0/0/0
no shutdown
ip address 10.0.23.145 255.255.255.252
interface serial 0/0/1
no shutdown
ip address 10.0.23.138 255.255.255.252
router eigrp 1
no auto-summary
network 10.0.23.148 0.0.0.3
network 10.0.23.144 0.0.0.3
network 10.0.23.136 0.0.0.3
do write
```

### RouterFrontend

```
enable
configure terminal
interface gigabitEthernet 0/0
no shutdown
ip address 10.0.23.129 255.255.255.248
interface serial 0/0/0
no shutdown
ip address 10.0.23.146 255.255.255.252
interface serial 0/0/1
no shutdown
ip address 10.0.23.142 255.255.255.252
router eigrp 1
no auto-summary
network 10.0.23.128 0.0.0.7
network 10.0.23.144 0.0.0.3
network 10.0.23.140 0.0.0.3
do write
```

### Ex2

```
enable
configure terminal
interface gigabitEthernet 0/0
no shutdown
ip address 80.80.23.2 255.255.255.252
interface gigabitEthernet 0/2
no shutdown
ip address 80.80.23.9 255.255.255.252
interface serial 0/0/0
no shutdown
ip address 192.168.23.137 255.255.255.252
interface serial 0/0/1
no shutdown
ip address 192.168.23.141 255.255.255.252
router rip
version 2
no auto-summary
network 192.168.23.128
redistribute ospf 1 metric 1
router ospf 1
network 80.80.23.0 0.0.0.3 area 1
network 80.80.23.8 0.0.0.3 area 1
redistribute rip metric 200 subnets
do write
```

### RouterD2

```
enable
configure terminal
interface gigabitEthernet 0/0
no shutdown
ip address 192.168.23.149 255.255.255.252
interface serial 0/0/0
no shutdown
ip address 192.168.23.138 255.255.255.252
interface serial 0/0/1
no shutdown
ip address 192.168.23.145 255.255.255.252
router rip
version 2
no auto-summary
network 192.168.23.128
do write
```

### Router Backend

```
enable
configure terminal
interface gigabitEthernet 0/0
no shutdown
ip address 192.168.23.129 255.255.255.248
interface serial 0/0/0
no shutdown
ip address 192.168.23.146 255.255.255.252
interface serial 0/0/1
no shutdown
ip address 192.168.23.142 255.255.255.252
router rip
version 2
no auto-summary
network 192.168.23.128
do write
```

## IV)

### RouterD1

```
interface tunnel 0
no shutdown
ip address 44.44.23.1 255.255.255.252
tunnel source serial 0/0/1
tunnel destination 192.168.23.138
tunnel mode gre ip
ip route 192.168.23.148 255.255.255.252 44.44.23.2
do write
```

### RouterD2

```
interface tunnel 0
no shutdown
ip address 44.44.23.2 255.255.255.252
tunnel source serial 0/0/0
tunnel destination 10.0.23.138
tunnel mode gre ip
ip route 10.0.23.148 255.255.255.252 44.44.23.1
do write
```

## VI)

### RouterD1

```
access-list 100 permit ip host 10.0.23.150 host 192.168.23.150
access-list 100 permit ip any any
access-list 101 permit ip host 192.168.23.150 host 10.0.23.150
access-list 101 permit tcp host 80.80.23.14 10.0.23.148 0.0.0.3 eq 22
access-list 101 permit udp any host 10.0.23.150 eq 53
interface gigabitEthernet 0/0
ip access-group 100 in
ip access-group 101 out
```

### RouterD2

```
access-list 100 permit ip host 192.168.23.150 host 10.0.23.150
access-list 100 permit ip any any
access-list 101 permit ip host 10.0.23.150 host 192.168.23.150
access-list 101 permit tcp host 80.80.23.14 192.168.23.148 0.0.0.3 eq 22
access-list 101 permit tcp any host 192.168.23.150 eq 80
access-list 101 permit tcp any host 192.168.23.150 eq 443
interface gigabitEthernet 0/0
ip access-group 100 in
ip access-group 101 out
```
