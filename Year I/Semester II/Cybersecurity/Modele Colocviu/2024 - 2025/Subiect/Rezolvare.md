## I)

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
interface gigabitEthernet 0/0
no shutdown
ip address 34.34.34.1 255.255.255.252
description "legatura cu R2"
interface gigabitEthernet 1/0
no shutdown
ip address 34.34.34.5 255.255.255.252
description "legatura cu R3"
interface gigabitEthernet 2/0
no shutdown
ip address 11.12.13.73 255.255.255.252
description "legatura cu R11"
interface gigabitEthernet 3/0
no shutdown
ip address 11.12.13.77 255.255.255.252
description "legatura cu R12"
router ospf 1
network 34.34.34.0 0.0.0.3 area 1
network 34.34.34.4 0.0.0.3 area 1
network 11.12.13.72 0.0.0.3 area 1
network 11.12.13.76 0.0.0.3 area 1
do write
```

### R11

```
enable
configure terminal
interface gigabitEthernet 0/0
no shutdown
ip address 11.12.13.74 255.255.255.252
interface gigabitEthernet 0/1
no shutdown
ip address 11.12.13.81 255.255.255.252
interface gigabitEthernet 0/2
no shutdown
ip address 11.12.13.85 255.255.255.252
router ospf 1
network 11.12.13.72 0.0.0.3 area 1
network 11.12.13.80 0.0.0.3 area 1
network 11.12.13.84 0.0.0.3 area 1
do write
```

### R12

```
enable
configure terminal
interface gigabitEthernet 0/0
no shutdown
ip address 11.12.13.78 255.255.255.252
interface gigabitEthernet 0/1
no shutdown
ip address 11.12.13.89 255.255.255.252
interface gigabitEthernet 0/2
no shutdown
ip address 11.12.13.65 255.255.255.248
router ospf 1
network 11.12.13.76 0.0.0.3 area 1
network 11.12.13.88 0.0.0.3 area 1
network 11.12.13.64 0.0.0.7 area 1
do write
```

### R2

```
enable
configure terminal
interface gigabitEthernet 0/0
no shutdown
ip address 34.34.34.2 255.255.255.252
interface gigabitEthernet 2/0
no shutdown
ip address 34.34.34.9 255.255.255.252
interface gigabitEthernet 1/0
no shutdown
ip address 21.31.41.137 255.255.255.252
interface gigabitEthernet 3/0
no shutdown
ip address 21.31.41.141 255.255.255.252
router ospf 1
network 34.34.34.0 0.0.0.3 area 1
network 34.34.34.8 0.0.0.3 area 1
network 21.31.41.136 0.0.0.3 area 1
network 21.31.41.140 0.0.0.3 area 1
do write
```

### R21

```
enable
configure terminal
interface gigabitEthernet 0/0
no shutdown
ip address 21.31.41.138 255.255.255.252
interface gigabitEthernet 0/1
no shutdown
ip address 21.31.41.145 255.255.255.252
interface gigabitEthernet 0/2
no shutdown
ip address 21.31.41.149 255.255.255.252
router ospf 1
network 21.31.41.136 0.0.0.3 area 1
network 21.31.41.144 0.0.0.3 area 1
network 21.31.41.148 0.0.0.3 area 1
do write
```

### R22

```
enable
configure terminal
interface gigabitEthernet 0/0
no shutdown
ip address 21.31.41.142 255.255.255.252
interface gigabitEthernet 0/1
no shutdown
ip address 21.31.41.153 255.255.255.252
interface gigabitEthernet 0/2
no shutdown
ip address 21.31.41.129 255.255.255.248
router ospf 1
network 21.31.41.140 0.0.0.3 area 1
network 21.31.41.152 0.0.0.3 area 1
network 21.31.41.128 0.0.0.7 area 1
do write
```

### R3

```
enable
configure terminal
interface gigabitEthernet 1/0
no shutdown
ip address 34.34.34.6 255.255.255.252
interface gigabitEthernet 2/0
no shutdown
ip address 34.34.34.10 255.255.255.252
interface gigabitEthernet 0/0
no shutdown
ip address 22.33.44.9 255.255.255.252
interface gigabitEthernet 3/0
no shutdown
ip address 22.33.44.13 255.255.255.252
router ospf 1
network 34.34.34.4 0.0.0.3 area 1
network 34.34.34.8 0.0.0.3 area 1
redistribute rip metric 200 subnets
router rip
version 2
no auto-summary
network 22.33.44.0
redistribute ospf 1 metric 1
do write
```

### R31

```
enable
configure terminal
interface gigabitEthernet 0/0
no shutdown
ip address 22.33.44.10 255.255.255.252
interface gigabitEthernet 0/2
no shutdown
ip address 22.33.44.17 255.255.255.252
interface gigabitEthernet 0/1
no shutdown
ip address 22.33.44.21 255.255.255.252
router rip
version 2
no auto-summary
network 22.33.44.0
do write
```

### R32

```
enable
configure terminal
interface gigabitEthernet 0/0
no shutdown
ip address 22.33.44.14 255.255.255.252
interface gigabitEthernet 0/1
no shutdown
ip address 22.33.44.25 255.255.255.252
interface gigabitEthernet 0/2
no shutdown
ip address 22.33.44.1 255.255.255.248
router rip
version 2
no auto-summary
network 22.33.44.0
do write
```

## IV)

### R11

```
interface tunnel 0
no shutdown
ip address 34.34.34.65 255.255.255.252
tunnel source gigabitEthernet 0/0
tunnel destination 22.33.44.10
tunnel mode gre ip
ip route 22.33.44.16 255.255.255.252 34.34.34.66
do write
```

### R31

```
interface tunnel 0
no shutdown
ip address 34.34.34.66 255.255.255.252
tunnel source gigabitEthernet 0/0
tunnel destination 11.12.13.74
tunnel mode gre ip
ip route 11.12.13.80 255.255.255.252 34.34.34.65
do write
```

## VI) ACL

### R1

```
access-list 100 permit tcp any host 11.12.13.91 eq 25
access-list 100 deny ip any host 11.12.13.91
access-list 100 permit ip any any
interface gigabitEthernet 2/0
ip access-group 100 out
interface gigabitEthernet 3/0
ip access-group 100 out
```

### R2

```
access-list 100 permit tcp any host 21.31.41.131 eq 80
access-list 100 permit tcp any host 21.31.41.131 eq 443
access-list 100 deny ip any host 21.31.41.131
access-list 100 deny tcp 22.33.44.0 0.0.0.31 21.31.41.128 0.0.0.31 eq 22
access-list 100 permit ip any any
interface gigabitEthernet 1/0
ip access-group 100 out
interface gigabitEthernet 3/0
ip access-group 100 out
```

### R3

```
access-list 100 permit udp any host 22.33.44.3 eq 53
access-list 100 deny ip any host 22.33.44.3
access-list 100 permit ip any any
interface gigabitEthernet 0/0
ip access-group 100 out
interface gigabitEthernet 3/0
ip access-group 100 out
```

