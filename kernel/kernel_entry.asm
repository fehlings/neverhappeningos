;Header to kernel to ensure that the cpu jumps to main
[bits 32]
[extern main]
    call main
    jmp $   