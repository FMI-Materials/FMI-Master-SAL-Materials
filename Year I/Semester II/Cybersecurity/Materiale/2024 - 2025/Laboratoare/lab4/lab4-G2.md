# lab4-G2

### R1

```
enable
configure terminal
interface serial0/0/0
no shutdown
ip address 100.100.100.33 255.255.255.252
interface gigabitEthernet0/0
no shutdown
ip address 10.10.10.1 255.255.255.248
router rip
version 2
no auto-summary
network 100.100.100.32
network 10.10.10.0
do write
```

### R2

```
enable
configure terminal
interface serial0/0/0
no shutdown
ip address 100.100.100.34 255.255.255.252
interface gigabitEthernet0/0
no shutdown
ip address 8.8.8.129 255.255.255.248
router rip
version 2
no auto-summary
network 100.100.100.32
network 8.8.8.128
do write
```

### R11

```
enable
configure terminal
interface gigabitEthernet0/0
no shutdown
ip address 10.10.10.2 255.255.255.248
interface gigabitEthernet0/1
no shutdown
ip address 10.10.10.9 255.255.255.248
router rip
version 2
no auto-summary
network 10.10.10.0
network 10.10.10.8
interface tunnel 0
ip address 1.2.3.5 255.255.255.252
tunnel source gigabitEthernet0/0
tunnel destination 8.8.8.130
tunnel mode gre ip
no shutdown
ip route 8.8.8.136 255.255.255.248 1.2.3.6
do write
```

### R12

```
enable
configure terminal
interface gigabitEthernet0/0
no shutdown
ip address 10.10.10.3 255.255.255.248
interface gigabitEthernet0/1
no shutdown
ip address 10.10.10.10 255.255.255.248
router rip
version 2
no auto-summary
network 10.10.10.0
network 10.10.10.8
do write
```

### R21

```
enable
configure terminal
interface gigabitEthernet0/0
no shutdown
ip address 8.8.8.130 255.255.255.248
interface gigabitEthernet0/1
no shutdown
ip address 8.8.8.137 255.255.255.248
router rip
version 2
no auto-summary
network 8.8.8.128
network 8.8.8.136
interface tunnel 0
ip address 1.2.3.6 255.255.255.252
tunnel source gigabitEthernet0/0
tunnel destination 10.10.10.2
tunnel mode gre ip
no shutdown
ip route 10.10.10.8 255.255.255.248 1.2.3.5
do write
```

### R22

```
enable
configure terminal
interface gigabitEthernet0/0
no shutdown
ip address 8.8.8.131 255.255.255.248
interface gigabitEthernet0/1
no shutdown
ip address 8.8.8.138 255.255.255.248
router rip
version 2
no auto-summary
network 8.8.8.128
network 8.8.8.136
do write
```
