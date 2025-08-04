# bonus

### Server Building Router

```
enable
configure terminal
interface gigabitEthernet0/0
no shutdown
ip address 192.168.0.1 255.255.255.248
interface gigabitEthernet0/1
no shutdown
ip address 192.168.0.9 255.255.255.248
router ospf 1
network 192.168.0.0 0.0.0.7 area 1
network 192.168.0.8 0.0.0.7 area 1
do write
```

### Wireless Building Router

```
enable
configure terminal
interface gigabitEthernet0/0
no shutdown
ip address 192.168.0.10 255.255.255.248
interface gigabitEthernet0/1
no shutdown
ip address 192.168.0.17 255.255.255.248
router ospf 1
network 192.168.0.8 0.0.0.7 area 1
network 192.168.0.16 0.0.0.7 area 1
do write
```

### VPN Router

```
enable
configure terminal
interface gigabitEthernet0/0
no shutdown
ip address 192.168.0.11 255.255.255.248
interface gigabitEthernet0/1
no shutdown
ip address 192.168.0.25 255.255.255.252
router ospf 1
network 192.168.0.8 0.0.0.7 area 1
redistribute eigrp 1 metric 100 subnets
router eigrp 1
network 192.168.0.24 0.0.0.3
redistribute ospf 1 metric 10000 100 255 1 1500
do write
```

### Extern

```
enable
configure terminal
interface gigabitEthernet0/0
no shutdown
ip address 192.168.0.26 255.255.255.252
interface gigabitEthernet0/1
no shutdown
ip address 192.168.0.29 255.255.255.252
interface gigabitEthernet0/2
no shutdown
ip address 192.168.0.33 255.255.255.252
router eigrp 1
network 192.168.0.24 0.0.0.3
network 192.168.0.28 0.0.0.3
network 192.168.0.32 0.0.0.3
do write
```

### Sales Router

```
enable
configure terminal
interface gigabitEthernet0/0
no shutdown
ip address 192.168.0.30 255.255.255.252
interface gigabitEthernet0/1
no shutdown
ip address 192.168.0.37 255.255.255.252
router eigrp 1
network 192.168.0.28 0.0.0.3
network 192.168.0.36 0.0.0.3
do write
```

### Hr Router

```
enable
configure terminal
interface gigabitEthernet0/0
no shutdown
ip address 192.168.0.34 255.255.255.252
interface gigabitEthernet0/1
no shutdown
ip address 192.168.0.41 255.255.255.252
router eigrp 1
network 192.168.0.32 0.0.0.3
network 192.168.0.40 0.0.0.3
do write
```
