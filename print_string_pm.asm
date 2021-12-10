;
; Prints out string stored in the ebx register
;
[bits 32]

VIDEO_MEMORY equ 0xb8000
WHITE_ON_BLACK equ 0x0f
print_string_pm:
    pusha               ; push registers to stack
    mov edx, VIDEO_MEMORY 
print_string_pm_loop:
    mov al, [ebx]       ; Move value at location stored in ebx to al
    mov ah, WHITE_ON_BLACK
    cmp al, 0           ; Check if string has ended
    je string_pm_return ; if string ended -> return
    mov [edx], ax       ; move character & attributes to cell
    add ebx, 1          ; next char in string
    add edx, 2          ; next cell in video memory
    jmp print_string_pm_loop  ; loop
string_pm_return:
    popa
    ret 