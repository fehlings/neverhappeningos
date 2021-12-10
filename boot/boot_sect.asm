; Boot sector that loads into 32-bit protected mode and boots the kernel
[org 0x7c00]

KERNEL_OFFSET equ 0x1000    ; Where the kernel is located

    mov [BOOT_DRIVE],  dl   ; Save boot drive
    mov bp, 0x9000          ; Stack
    mov sp, bp
    
    mov bx, MSG_REAL_MODE
    call print_string
    
    call load_kernel
    call switch_to_pm

    jmp $

; Routines
%include "gdt.asm"
%include "print_string.asm"
%include "disk_load.asm"
%include "print_string_pm.asm"
%include "switch_to_pm.asm"

[bits 16]
load_kernel:
    mov bx, MSG_LOAD_KERNEL
    call print_string     
    mov bx, KERNEL_OFFSET       
    mov dh, 15                  ; Amount of sectors loaded
    mov dl, [BOOT_DRIVE]
    call disk_load
    ret

[bits 32]
; yay PM!
BEGIN_PM:
    mov ebx, MSG_PROT_MODE
    call print_string_pm
    call KERNEL_OFFSET          ; Jump to kernel

    jmp $

; Globals 
BOOT_DRIVE      db 0
MSG_REAL_MODE   db "Entered 16-bit Real Mode", 0
MSG_PROT_MODE   db "Entered 32-bit Protected Mode", 0
MSG_LOAD_KERNEL db "Loading kernel into memory", 0
MSG_DEBUG       db "DEBUG", 0

; Bootsector
    times 510-($-$$) db 0
    dw 0xaa55


