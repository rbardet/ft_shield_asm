%include "ft_shield.inc"

section .data
    addr istruc sockaddr_in
        at sockaddr_in.sin_family, dw AF_INET
        at sockaddr_in.sin_port, dw PORT
        at sockaddr_in.sin_addr, dd INADDR_ANY
        at sockaddr_in.sin_zero,dd 0, 0
    iend
    addr_len equ $ - addr

    SOCKET_ERR dd "Error while creating socket", 10
    SOCKET_ERR_LEN equ $ - SOCKET_ERR
    SETOPT_ERR dd "Error while setting socket option", 10
    SETOPT_ERR_LEN equ $ - SETOPT_ERR
    BIND_ERR dd "Error while binding server", 10
    BIND_ERR_LEN equ $ - BIND_ERR
    LISTEN_ERR dd "Error while listening server", 10
    LISTEN_ERR_LEN equ $ - LISTEN_ERR

    opt dd 1
    opt_len equ $ - opt

section .text
    global init_server

init_server:
    mov word[sockfd], 0
    call socket
    call setsockopt
    call bind
    call listen
    ret

close_socket:
    mov rax, SYS_CLOSE
    mov rdi, [sockfd]
    syscall
    ret

socket:
    mov rax, SYS_SOCKET
    mov rdi, AF_INET
    mov rsi, SOCK_STREAM
    mov rdx, 0
    syscall
    cmp rax, 0
    jl .err_socket
    mov [sockfd], rax
    ret
.err_socket:
    print STD_ERR, SOCKET_ERR, SOCKET_ERR_LEN
    exit EXIT_FAILURE

setsockopt:
    mov rax, SYS_SETSOCKOPT
    mov rdi, [sockfd]
    mov rsi, SOL_SOCKET
    mov rdx, SO_REUSEADDR
    mov r10, [opt]
    mov r9, opt_len
    syscall
    cmp rax, 0
    jl .err_setopt
.err_setopt:
    call close_socket
    print STD_ERR, SETOPT_ERR, SETOPT_ERR_LEN
    exit EXIT_FAILURE

bind:
    mov rdi, [sockfd]
    mov rsi, addr
    mov rdx, addr_len
    syscall
    cmp rax, 0
    jl .err_bind
    ret
.err_bind:
    call close_socket
    print STD_ERR, BIND_ERR, BIND_ERR_LEN
    exit EXIT_FAILURE

listen:
    mov rax, SYS_LISTEN
    mov rsi, MAX_USER
    syscall
    cmp rax, 0
    jl .err_listen
    ret
.err_listen:
    call close_socket
    print STD_ERR, LISTEN_ERR, LISTEN_ERR_LEN
    exit EXIT_FAILURE