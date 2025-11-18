section .data
    STD_OUT equ 1
    LOGIN dq "rbardet-", 10
    LOGIN_LEN equ $ - LOGIN

section .text
    global _start
    global exit
    extern SYS_WRITE
    extern SYS_EXIT
    extern ft_shield

exit:
    mov rdi, rax
    mov rax, SYS_EXIT
    syscall

_start:
    call ft_shield
    mov rax, SYS_WRITE
    mov rdi, STD_OUT
    mov rsi, LOGIN
    mov rdx, LOGIN_LEN
    syscall
    xor rax,rax
    call exit