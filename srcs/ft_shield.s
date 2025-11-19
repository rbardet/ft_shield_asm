%include "ft_shield.inc"

section .data
    NO_ROOT dd "sudo right needed", 10
    NO_ROOT_LEN equ $ - NO_ROOT

section .text
    global ft_shield
    extern create_lock
    extern existing_lock
    extern init_server
    extern init_epoll
    extern run_server

ft_shield:
    mov rax, SYS_GETUID
    syscall
    cmp rax, 0
    jne .err_root
    call existing_lock
    call create_lock
    call init_server
    call init_epoll
    call run_server
    ret
.err_root:
    print STD_ERR, NO_ROOT, NO_ROOT_LEN
    exit EXIT_FAILURE
    ret