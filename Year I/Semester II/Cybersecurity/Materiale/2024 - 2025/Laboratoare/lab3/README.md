# lab3

## Routing Protocol Redistribution ([Cisco documentation](https://www.cisco.com/c/en/us/support/docs/ip/enhanced-interior-gateway-routing-protocol-eigrp/8606-redist.html))

### R1

```
enable
configure terminal
interface gigabitEthernet0/0
no shutdown
ip address 10.0.0.1 255.255.255.252
interface gigabitEthernet0/1
no shutdown
ip address 10.0.0.5 255.255.255.252
router rip
version 2
no auto-summary
network 10.0.0.0
do write
```

### R2

```
enable
configure terminal
interface serial0/0/0
no shutdown
ip address 10.0.0.9 255.255.255.252
interface serial0/0/1
no shutdown
ip address 10.0.0.13 255.255.255.252
router rip
version 2
no auto-summary
network 10.0.0.0
do write
```

### R3

```
enable
configure terminal
interface gigabitEthernet0/0
no shutdown
ip address 172.16.0.1 255.255.255.252
interface gigabitEthernet0/1
no shutdown
ip address 172.16.0.5 255.255.255.252
ip route 172.16.0.8 255.255.255.252 gigabitEthernet0/0
ip route 172.16.0.12 255.255.255.252 gigabitEthernet0/1
ip route 10.0.0.0 255.255.255.224 gigabitEthernet0/0
ip route 192.168.0.0 255.255.255.240 gigabitEthernet0/1
ip route 20.0.0.0 255.255.255.224 gigabitEthernet0/1
do write
```

### R4

```
enable
configure terminal
interface serial0/0/0
no shutdown
ip address 172.16.0.9 255.255.255.252
interface serial0/0/1
no shutdown
ip address 172.16.0.13 255.255.255.252
ip route 172.16.0.0 255.255.255.252 serial0/0/0
ip route 172.16.0.4 255.255.255.252 serial0/0/1
ip route 10.0.0.0 255.255.255.224 serial0/0/0
ip route 192.168.0.0 255.255.255.240 serial0/0/1
ip route 20.0.0.0 255.255.255.224 serial0/0/1
do write
```

### R5

```
enable
configure terminal
interface gigabitEthernet0/0
no shutdown
ip address 192.168.0.1 255.255.255.252
interface gigabitEthernet0/1
no shutdown
ip address 192.168.0.5 255.255.255.252
router eigrp 1
network 192.168.0.0 0.0.0.3
network 192.168.0.4 0.0.0.3
no auto-summary
do write
```

### R6

```
enable
configure terminal
interface serial0/0/0
no shutdown
ip address 192.168.0.9 255.255.255.252
interface serial0/0/1
no shutdown
ip address 192.168.0.13 255.255.255.252
router eigrp 1
network 192.168.0.8 0.0.0.3
network 192.168.0.12 0.0.0.3
no auto-summary
do write
```

### R7

```
enable
configure terminal
interface gigabitEthernet0/0
no shutdown
ip address 20.0.0.1 255.255.255.252
interface gigabitEthernet0/1
no shutdown
ip address 20.0.0.5 255.255.255.252
router ospf 1
network 20.0.0.0 0.0.0.3 area 1
network 20.0.0.4 0.0.0.3 area 1
do write
```

### R8

```
enable
configure terminal
interface serial0/0/0
no shutdown
ip address 20.0.0.9 255.255.255.252
interface serial0/0/1
no shutdown
ip address 20.0.0.13 255.255.255.252
router ospf 1
network 20.0.0.8 0.0.0.3 area 1
network 20.0.0.12 0.0.0.3 area 1
do write
```

### R9

```
enable
configure terminal
interface gigabitEthernet0/0
no shutdown
ip address 10.0.0.2 255.255.255.252
interface gigabitEthernet0/2
no shutdown
ip address 10.0.0.17 255.255.255.252
interface serial0/0/0
no shutdown
ip address 10.0.0.10 255.255.255.252
router rip
version 2
no auto-summary
network 10.0.0.0
do write
```

### R10

```
enable
configure terminal
interface gigabitEthernet0/0
no shutdown
ip address 172.16.0.2 255.255.255.252
interface gigabitEthernet0/1
no shutdown
ip address 10.0.0.6 255.255.255.252
interface serial0/0/0
no shutdown
ip address 172.16.0.10 255.255.255.252
interface serial0/0/1
no shutdown
ip address 10.0.0.14 255.255.255.252
router rip
version 2
no auto-summary
network 10.0.0.0
redistribute static metric 1
ip route 172.16.0.4 255.255.255.252 gigabitEthernet0/0
ip route 172.16.0.12 255.255.255.252 serial0/0/0
ip route 192.168.0.0 255.255.255.240 serial0/0/0
ip route 20.0.0.0 255.255.255.224 serial0/0/0
do write
```

### R11

```
enable
configure terminal
interface gigabitEthernet0/0
no shutdown
ip address 192.168.0.2 255.255.255.252
interface gigabitEthernet0/1
no shutdown
ip address 172.16.0.6 255.255.255.252
interface serial0/0/0
no shutdown
ip address 192.168.0.10 255.255.255.252
interface serial0/0/1
no shutdown
ip address 172.16.0.14 255.255.255.252
router eigrp 1
network 192.168.0.0 0.0.0.3
network 192.168.0.8 0.0.0.3
no auto-summary
redistribute static metric 10000 100 255 1 1500
ip route 172.16.0.0 255.255.255.252 gigabitEthernet0/1
ip route 172.16.0.8 255.255.255.252 serial0/0/1
ip route 10.0.0.0 255.255.255.224 serial0/0/1
do write
```

### R12

```
enable
configure terminal
interface gigabitEthernet0/0
no shutdown
ip address 20.0.0.2 255.255.255.252
interface gigabitEthernet0/1
no shutdown
ip address 192.168.0.6 255.255.255.252
interface serial0/0/0
no shutdown
ip address 20.0.0.10 255.255.255.252
interface serial0/0/1
no shutdown
ip address 192.168.0.14 255.255.255.252
router eigrp 1
network 192.168.0.4 0.0.0.3
network 192.168.0.12 0.0.0.3
no auto-summary
redistribute ospf 1 metric 10000 100 255 1 1500
router ospf 1
network 20.0.0.0 0.0.0.3 area 1
network 20.0.0.8 0.0.0.3 area 1
redistribute eigrp 1 metric 100 subnets
do write
```

### R13

```
enable
configure terminal
interface gigabitEthernet0/1
no shutdown
ip address 20.0.0.6 255.255.255.252
interface gigabitEthernet0/2
no shutdown
ip address 20.0.0.17 255.255.255.252
interface serial0/0/1
no shutdown
ip address 20.0.0.14 255.255.255.252
router ospf 1
network 20.0.0.4 0.0.0.3 area 1
network 20.0.0.12 0.0.0.3 area 1
network 20.0.0.16 0.0.0.3 area 1
do write
```
