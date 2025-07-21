section .data
    x       dd 5               ; number to calculate factorial of
    msg     db "Factorial: "   ; message to print (no null terminator)
    msg_len equ $ - msg
    newline db 10              ; newline character

section .bss
    strbuf  resb 12            ; buffer to hold factorial result as string

section .text
    global _start

_start:
    mov eax, [x]               ; load x into eax
    mov ebx, eax               ; copy x to ebx, used as loop counter
    mov ecx, 1                 ; initialize factorial result accumulator to 1

.factorial_loop:
    cmp ebx, 1                 ; check if ebx > 1
    jl .done                   ; if less than 1, factorial complete
    imul ecx, ebx              ; multiply accumulator by ebx
    dec ebx                    ; decrement ebx
    jmp .factorial_loop        ; repeat loop

.done:
    mov eax, ecx               ; move factorial result into eax
    mov edi, strbuf + 11       ; point edi to end of buffer
    mov byte [edi], 0          ; null terminate string buffer

.convert_loop:
    dec edi                    ; move one byte back
    xor edx, edx               ; clear edx for division
    mov ebx, 10
    div ebx                    ; divide eax by 10; quotient in eax, remainder in edx
    add dl, '0'                ; convert remainder to ASCII digit
    mov [edi], dl              ; store digit in buffer
    test eax, eax              ; check if quotient is zero
    jnz .convert_loop          ; if not zero, continue converting

    ; print the message "Factorial: "
    mov eax, 4                 ; syscall number (sys_write)
    mov ebx, 1                 ; file descriptor (stdout)
    mov ecx, msg               ; message to write
    mov edx, msg_len           ; message length
    int 0x80                   ; make syscall

    ; print the factorial number string
    mov eax, 4
    mov ebx, 1
    mov ecx, edi               ; pointer to start of string
    mov edx, strbuf + 11
    sub edx, edi               ; calculate string length
    int 0x80

    ; print newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; exit program
    mov eax, 1
    xor ebx, ebx
    int 0x80
