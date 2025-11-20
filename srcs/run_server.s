%include "ft_shield.inc"

section .data
    TOOMANY_USER dd "Error too many user, try later", 10
    TOOMANY_USER_LEN equ $ - TOOMANY_USER
    ERR_EPCTL dd "Error while connecting to server, try later", 10
    ERR_EPCTL_LEN equ $ - ERR_EPCTL
    GOODBYE dd "Goodbye.", 10
    GOODBYE_LEN equ $ - GOODBYE
    HERE dd "HERE", 10
    HERE_LEN equ $ - HERE
    EP dd "EPOLL WAIT", 10
    EP_LEN equ $ - EP

section .text
    global run_server
    extern handle_input

run_server:
.server_loop:
    print STD_OUT, EP, EP_LEN
    mov rax, SYS_EPOLL_WAIT
    mov rdi, r15
    lea rsi, [events]
    mov rdx, MAX_EVENT
    mov r10, TIMEOUT
    syscall
    cmp rax, 0
    jl .server_loop
    xor r14, r14
    mov r13, [events + epoll_event.data]
    mov rbp, rax
.handle_event:
    cmp rbp, r14
    je .server_loop
    inc r14
    cmp r13, rbx
    mov r12, r13 
    je .handle_user
.read_input:
    read r13, buff, BUFFER_SIZE
    cmp rax, 0
    je .disconnect_user
    jl .handle_event
    mov byte[buff + rax], 0
    push r15
    mov r15, rax
    print STD_OUT, buff, r15
    pop r15
    call handle_input
    jmp .handle_event
.handle_user:
    mov r12, [usernb]
    cmp r12, MAX_USER
    je .refuse_user
    jmp .accept_user
.accept_user:
    mov rax, SYS_ACCEPT
    mov rdi, rbx
    mov rsi, 0
    mov rdx, 0
    syscall
    cmp rax, 0
    jl .err_accept
    mov [userfd], rax
    setnon_block [userfd]
    mov rax,[userfd]
    mov dword[user_epoll + epoll_event.events], EPOLLIN
    mov qword[user_epoll + epoll_event.data], rax
    epoll_ctl r15, EPOLL_CTL_ADD, [userfd], [user_epoll]
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
    epoll_ctl r15, EPOLL_CTL_DEL, r13, [server_epoll]
    dec byte [usernb]
    jmp .handle_event
.err_epoll:
    print [userfd], ERR_EPCTL, ERR_EPCTL_LEN
    close_file [userfd]
    jmp .handle_event
.err_accept:
    jmp .handle_event