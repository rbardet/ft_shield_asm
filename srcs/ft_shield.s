section .data
    NO_ROOT db "sudo right needed", 10
    NO_ROOT_LEN equ $ - NO_ROOT
    STD_ERR equ 2

section .text
    global ft_shield
    global print_error
    extern create_lock
    extern existing_lock
    extern exit
    extern SYS_WRITE
    extern SYS_GETUID

print_error:
    mov rax, SYS_WRITE
    mov rdi, STD_ERR
    syscall
    ret

ft_shield:
    mov rax, SYS_GETUID
    syscall
    cmp rax, 0
    jne .err_root
    call existing_lock
    call create_lock
    ret
.err_root:
    mov rsi, NO_ROOT
    mov rdx, NO_ROOT_LEN
    call print_error
    call exit
    ret