;
; load DH sectors to ES:BX from drive DL
;
disk_load:
    push dx
    mov ah, 0x02        ; BIOS read sector
    mov al, dh      
    mov ch, 0x00        ; cylinder
    mov dh, 0x00        ; head
    mov cl, 0x02        ; sector
    int 0x13
    jc disk_error       ; jump if error
    pop dx
    cmp dh, al
    jne disk_error      ; jump if sectors read != sectors expected
    ret
disk_error:
    mov bx, DISK_ERROR_MSG
    call print_string
    jmp $

DISK_ERROR_MSG db "Disk read error!", 0