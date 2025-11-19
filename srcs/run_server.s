%include "ft_shield.inc"

section .data
    TOOMANY_USER dd "Error too many user, try later", 10
    TOOMANY_USER_LEN equ $ - TOOMANY_USER
    ERR_EPCTL dd "Error while connecting to server, try later", 10
    ERR_EPCTL_LEN equ $ - ERR_EPCTL
    GOODBYE dd "Goodbye.", 10
    GOODBYE_LEN equ $ - GOODBYE
    HERE dd "HERE", 10
    HERE_LEN equ $ - ERR_EPCTL
section .text
    global run_server

next_event:
    mov rax, r14
    imul rax, EPOLL_EVENT_SIZE
    lea r13, [events + rax]
    ret

run_server:
.server_loop:
    mov rax, SYS_EPOLL_WAIT
    mov rdi, r15
    lea rsi, [events]
    mov rdx, MAX_EVENT
    mov r10, TIMEOUT
    syscall
    cmp rax, 0
    jl .server_loop
    xor r14, r14
    mov r11, [events + epoll_event.data]
    mov rbp, rax
.handle_event:
    cmp rbp, r14
    je .server_loop
    call next_event
    cmp [r13 + epoll_event.data], rbx
    je .handle_user
.read_input:
    read r13, rsi, BUFFER_SIZE
    cmp rax, 0
    je .disconnect_user
    jl .handle_event
    print STD_OUT, rsi, BUFFER_SIZE
    inc r14
    jmp .handle_event
.handle_user:
    PUSH r12
    mov r12, [usernb]
    cmp r12, MAX_USER
    POP r12
    je .refuse_user
    jmp .accept_user
.accept_user:
    print STD_OUT, HERE, HERE_LEN
    mov rax, SYS_ACCEPT
    mov rdi, rbx
    mov rsi, 0
    mov rdx, 0
    syscall
    cmp rax, 0
    jl .err_accept
    mov [userfd], rax
    mov dword[epoll + epoll_event.events], EPOLLIN
    mov qword[epoll + epoll_event.data], rax
    epoll_ctl r15, EPOLL_CTL_ADD, [userfd]
    cmp rax, 0
    jl .err_epoll
    inc byte [usernb]
    jmp .handle_event
.refuse_user:
    mov rax, SYS_ACCEPT
    mov rdi, rbx
    mov rsi, 0
    mov rdx, 0
    syscall
    cmp rax, 0
    jl .err_accept
    mov [userfd], rax
    print [userfd], TOOMANY_USER, TOOMANY_USER_LEN
    close_file [userfd]
    jmp .handle_event
.disconnect_user:
    print r13, GOODBYE, GOODBYE_LEN
    close_file r13
    epoll_ctl r15, EPOLL_CTL_DEL, r13
    dec byte [usernb]
    jmp .handle_event
.err_epoll:
    print r14, ERR_EPCTL, ERR_EPCTL_LEN
    close_file r14
    jmp .handle_event
.err_accept:
    jmp .handle_event