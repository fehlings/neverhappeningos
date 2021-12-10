;
; Prints 16 bit hex value stored in dx register, with HEX_OUT as a dummy
;
print_hex:
    pusha
    mov cx, 4       ; counter  
print_hex_loop:
    dec cx          ; decrease counter 
    mov ax, dx      ; copy hex into ax
    and ax, 0xf     ; get last four bits
    shr dx, 4       ; Shift four bits to the right
    mov bx, HEX_OUT ; move address of string
    add bx, 2       ; Skip '0x'
    add bx, cx      ; go to respective char 
    cmp ax, 0xa     ; number or letter?
    jl add_number  
    add ax, 0x27      ; offset for ASCII letters
add_number:
    add [bx], ax    ; adds value to value at address stored in bx
    cmp cx, 0       ; check counter
    je print_hex_return   
    jmp print_hex_loop
print_hex_return:
    mov bx, HEX_OUT
    call print_string
    popa
    call restore_hex
    ret
restore_hex:
    pusha
    mov cx, 4       ; counter  
restore_hex_loop:
    dec cx          ; decrease counter 
    mov ax, dx      ; copy hex into ax
    and ax, 0xf     ; get last four bits
    shr dx, 4       ; Shift four bits to the right
    mov bx, HEX_OUT ; move address of string
    add bx, 2       ; Skip '0x'
    add bx, cx      ; go to respective char 
    cmp ax, 0xa     ; number or letter?
    jl sub_number  
    add ax, 0x27      ; offset for ASCII letters
sub_number:
    sub [bx], ax    ; adds value to value at address stored in bx
    cmp cx, 0       ; check counter
    je restore_hex_return   
    jmp restore_hex_loop
restore_hex_return:
    mov bx, HEX_OUT
    popa
    ret
HEX_OUT: db '0x0000',0 