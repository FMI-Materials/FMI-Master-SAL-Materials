# lab4-G1

### Frontend

```
enable
configure terminal
interface gigabitEthernet0/0
no shutdown
ip address 40.40.0.57 255.255.255.252
interface gigabitEthernet0/2
no shutdown
ip address 80.44.44.1 255.255.255.248
router ospf 1
network 40.40.0.56 0.0.0.3 area 1
network 80.44.44.0 0.0.0.7 area 1
do write
```

### R1_Frontend

```
enable
configure terminal
interface gigabitEthernet0/0
no shutdown
ip address 80.44.44.9 255.255.255.252
interface gigabitEthernet0/1
no shutdown
ip address 80.44.44.2 255.255.255.248
router ospf 1
network 80.44.44.0 0.0.0.7 area 1
network 80.44.44.8 0.0.0.3 area 1
interface tunnel 0
ip address 4.8.12.17 255.255.255.252
tunnel source gigabitEthernet0/1
tunnel destination 4.4.60.66
tunnel mode gre ip
no shutdown
ip route 4.4.60.72 255.255.255.252 4.8.12.18
do write
```

### R2_Frontend

```
enable
configure terminal
interface gigabitEthernet0/0
no shutdown
ip address 80.44.44.13 255.255.255.252
interface gigabitEthernet0/2
no shutdown
ip address 80.44.44.3 255.255.255.248
router ospf 1
network 80.44.44.0 0.0.0.7 area 1
network 80.44.44.12 0.0.0.3 area 1
do write
```

### Internet

```
enable
configure terminal
interface gigabitEthernet0/0
no shutdown
ip address 40.40.0.58 255.255.255.252
interface gigabitEthernet0/1
no shutdown
ip address 40.40.0.61 255.255.255.252
interface gigabitEthernet0/2
no shutdown
ip address 40.40.0.49 255.255.255.248
router ospf 1
network 40.40.0.48 0.0.0.7 area 1
network 40.40.0.56 0.0.0.3 area 1
network 40.40.0.60 0.0.0.3 area 1
do write
```

### Backend

```
enable
configure terminal
interface gigabitEthernet0/1
no shutdown
ip address 40.40.0.62 255.255.255.252
interface gigabitEthernet0/2
no shutdown
ip address 4.4.60.65 255.255.255.248
router ospf 1
network 40.40.0.60 0.0.0.3 area 1
network 4.4.60.64 0.0.0.7 area 1
do write
```

### R1_Backend

```
enable
configure terminal
interface gigabitEthernet0/0
no shutdown
ip address 4.4.60.73 255.255.255.252
interface gigabitEthernet0/1
no shutdown
ip address 4.4.60.66 255.255.255.248
router ospf 1
network 4.4.60.64 0.0.0.7 area 1
network 4.4.60.72 0.0.0.3 area 1
interface tunnel 0
ip address 4.8.12.18 255.255.255.252
tunnel source gigabitEthernet0/1
tunnel destination 80.44.44.2
tunnel mode gre ip
no shutdown
ip route 80.44.44.8 255.255.255.252 4.8.12.17
do write
```

### R2_Backend

```
enable
configure terminal
interface gigabitEthernet0/0
no shutdown
ip address 4.4.60.77 255.255.255.252
interface gigabitEthernet0/2
no shutdown
ip address 4.4.60.67 255.255.255.248
router ospf 1
network 4.4.60.64 0.0.0.7 area 1
network 4.4.60.76 0.0.0.3 area 1
do write
```
