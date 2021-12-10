[bits 16]
; Switch to protected mode
switch_to_pm:
    cli     ; switch of interrupts
    lgdt [gdt_descriptor]
    mov eax, cr0
    or eax, 0x1
    mov cr0, eax
    jmp CODE_SEG:init_pm    ; far jump to 32 bit code, flushes instructions

[bits 32]
init_pm:
    mov ax, DATA_SEG        ; update segment registers to
    mov ds, ax              ; the new data selector in GDT
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov ebp, 0x90000
    mov esp, ebp            ; move stack to new segment

    call BEGIN_PM