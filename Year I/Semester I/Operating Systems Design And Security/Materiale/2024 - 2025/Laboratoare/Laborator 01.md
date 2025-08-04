# Laborator 1

## Exercise 1 - Inspecting Virtual Memory
### [Q1]: Where is each section mapped? Try using the `search` command in `pwndbg` (or `search-pattern` in `GEF`).
### Solution to [Q1]:
`.bss`, `.data`:
```python
0x404000           0x405000 rw-p     1000   3000 /home/radu/osds-lab/lab1/bin/ex1
```

`.text`:
```python
0x401000           0x402000 r-xp     1000   1000 /home/radu/osds-lab/lab1/bin/ex1
```

`.rodata`:
```python
0x402000           0x403000 r--p     1000   2000 /home/radu/osds-lab/lab1/bin/ex1
```

### [Q2]: Try finding the address of bar() in gdb and printing its disassembly.
### Solution to [Q2]:

```python
pwndbg> info address bar
Symbol "bar" is a function at address 0x401136.
```

```python
pwndbg> disassemble bar
Dump of assembler code for function bar:
   0x0000000000401136 <+0>:     endbr64
   0x000000000040113a <+4>:     push   rbp
   0x000000000040113b <+5>:     mov    rbp,rsp
   0x000000000040113e <+8>:     sub    rsp,0x20
   0x0000000000401142 <+12>:    mov    DWORD PTR [rbp-0x14],edi
   0x0000000000401145 <+15>:    mov    QWORD PTR [rbp-0x20],rsi
   0x0000000000401149 <+19>:    mov    DWORD PTR [rbp-0x4],0x0
   0x0000000000401150 <+26>:    jmp    0x401165 <bar+47>
   0x0000000000401152 <+28>:    lea    rax,[rip+0x2ec7]        # 0x404020 <useful>
   0x0000000000401159 <+35>:    mov    rdi,rax
   0x000000000040115c <+38>:    call   0x401040 <puts@plt>
   0x0000000000401161 <+43>:    add    DWORD PTR [rbp-0x4],0x1
   0x0000000000401165 <+47>:    mov    eax,DWORD PTR [rbp-0x4]
   0x0000000000401168 <+50>:    cmp    eax,DWORD PTR [rbp-0x14]
   0x000000000040116b <+53>:    jl     0x401152 <bar+28>
   0x000000000040116d <+55>:    nop
   0x000000000040116e <+56>:    nop
   0x000000000040116f <+57>:    leave
   0x0000000000401170 <+58>:    ret
```

## Exercise 2 - Baby's first executable loader
### [Q3]: Check `gdb` with your binary. How does `vmmap` look after running `mmap`? You can step through each line of code with `next` or `n`. You can step through each assembly instruction with `next instruction` or `ni`.

### Solution to [Q3]:
```
objdump -d dummy -F
```


Modify `ex2.c`:
```c

#include <stdio.h>
#include <sys/mman.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>

int main() {
        FILE *f = fopen("./bin/dummy", "rb");
        if (!f) {
                perror("fopen");
                return 1;
        }

        off_t foo_offset = 0x1106;

        fseek(f, foo_offset, SEEK_SET);

        unsigned char buffer[100];
        fread(buffer, 1, sizeof(buffer), f);



        void *exec_mem = mmap(NULL, sizeof(buffer), PROT_READ | PROT_WRITE | PROT_EXEC, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
         if (exec_mem == MAP_FAILED) {
                  perror("mmap");
                  return 1;
         }

         memcpy(exec_mem, buffer, sizeof(buffer));

         fclose(f);

         (*(void(*)()) exec_mem)();

         return 0;
}
```

After executing `mmap`, a new region appears in `vmmap`:
```python
0x7ffff7fbc000     0x7ffff7fbd000 rwxp     1000      0 [anon_7ffff7fbc]
```
`rwxp` <-> `PROT_READ | PROT_WRITE | PROT_EXEC, MAP_PRIVATE`

`[anon_7ffff7fbc]` <-> `MAP_ANONYMOUS`

## Exercise 3 - Stacks, calling conventions and mind controlling execution
### [Q4]: Can you identify the arguments of a function call in the disassembly?
### Solution to [Q4]:
```python
  4012ba:       48 89 c6                mov    %rax,%rsi
  4012bd:       89 d7                   mov    %edx,%edi
  4012bf:       e8 00 ff ff ff          call   4011c4 <advertisment>
```

### [Q5]: Did you get a `SIGSEGV` in `printf()`? What causes it? `pwndbg` hints at the reason.
### Solution to [Q5]:
```python
__GI__IO_puts (str=0x1337 <error: Cannot access memory at address 0x1337>) at ./libio/ioputs.c:33
```

## Extra Challenges
### 1. Filesystem Crawler
### Solution to 1.:
- Environment variables (API keys, database credentials, etc.)
- Server configuration details

### 2. ELF Pro
### Solution to 2.:
```c
#include <stdio.h>
#include <stdlib.h>
#include <elf.h>

void parse_elf_header(FILE *file) {
    Elf64_Ehdr header;

    fread(&header, 1, sizeof(header), file);

    printf("ELF Header:\n");
    printf("  Magic: %02x %02x %02x %02x\n", 
           header.e_ident[EI_MAG0],
           header.e_ident[EI_MAG1],
           header.e_ident[EI_MAG2],
           header.e_ident[EI_MAG3]);
    printf("  Class: %d\n", header.e_ident[EI_CLASS]);
    printf("  Data: %d\n", header.e_ident[EI_DATA]);
    printf("  Version: %d\n", header.e_ident[EI_VERSION]);
    printf("  OS/ABI: %d\n", header.e_ident[EI_OSABI]);
    printf("  Type: %d\n", header.e_type);
    printf("  Machine: %d\n", header.e_machine);
    printf("  Entry point address: 0x%lx\n", header.e_entry);
    printf("  Start of section headers: %ld (bytes into file)\n", header.e_shoff);
    printf("  Number of section headers: %d\n", header.e_shnum);
}

void parse_section_headers(FILE *file, Elf64_Ehdr *header) {
    Elf64_Shdr section;

    fseek(file, header->e_shoff, SEEK_SET);

    printf("\nSection Headers:\n");
    for (int i = 0; i < header->e_shnum; i++) {
        fread(&section, 1, sizeof(section), file);

        printf("  [%2d] Offset: 0x%lx, Size: 0x%lx, Type: %d\n", 
               i, section.sh_offset, section.sh_size, section.sh_type);
    }
}

int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <ELF file>\n", argv[0]);
        return EXIT_FAILURE;
    }

    FILE *file = fopen(argv[1], "rb");
    if (!file) {
        perror("Error opening file");
        return EXIT_FAILURE;
    }

    Elf64_Ehdr header;
    fread(&header, 1, sizeof(header), file);
    parse_elf_header(file);

    parse_section_headers(file, &header);

    fclose(file);
    return EXIT_SUCCESS;
}
```

### 3. Control-flow Trickster
### Solution to 3.:
ret2libc