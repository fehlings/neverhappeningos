;
; Prints out string stored in the bx register
;

print_string:
    pusha           ; push registers to stack
    mov ah, 0x0e    ; BIOS tele-type ISC
print_loop:
    mov cx, [bx]    ; Move value at location stored in bx to cx
    cmp cl, 0       ; Check if string has ended
    je return       ; if string ended -> return
    mov al, [bx]    ; move character to al
    int 0x10        ; interrupt to print
    add bx, 0x01    ; go to next character
    jmp print_loop  ; loop
return:
    popa
    ret 