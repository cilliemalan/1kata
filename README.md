# 1 Kata, 3 Languages
Not my original idea. But this is a survey of solving a
simple problem (writing a program to calculate a factorial)
using 3 different languages. The three languages are
x64 assembly, c, and haskell.

# Requirements
The sources are designed to be built and run on Linux.
The c and haskell sources should work in Windows with
some expertise. The assembly one uses hardcoded Linux
syscalls, so no platform independence there.

# Compiling
How to compile the stuff

## Assembly
Run this:
```sh
nasm factorial.asm -g -o factorial.o -f elf64 -l factorial.lst
ld -e _start -o factorial factorial.o
```

## C
Run this:
```sh
gcc factorial.c -o factorial
```

## Haskell
Run this:
```sh
ghc -O factorial.hs
```

# Running
All programs should run the same, with some nuances:
```sh
# will return 120
./factorial 5
```
