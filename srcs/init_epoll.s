%include "ft_shield.inc"

section .bss
    epoll resb EPOLL_EVENT_SIZE

section .data
    EPOLL_ERR dd "Error while creating epoll", 10
    EPOLL_ERR_LEN equ $ - EPOLL_ERR
    EPCTL_ERR dd "Error while adding server to epoll", 10
    EPCTL_ERR_LEN equ $ - EPCTL_ERR

section .text
    global init_epoll

init_epoll:
    mov qword[epollfd], 0
    mov dword[epoll + epoll_event.events], EPOLLIN
    mov rbx, [sockfd]
    mov qword[epoll + epoll_event.data], rbx
.create_epoll:
    mov rax, SYS_EPOLL_CREATE1
    mov rdi, 0
    syscall
    cmp rax, 0
    jl .err_epoll
    mov [epollfd], rax
.add_sockfd:
    MOV rax, SYS_EPOLL_CTL
    mov rdi, [epollfd]
    mov rsi, EPOLL_CTL_ADD
    mov rdx, [sockfd]
    mov r10, epoll
    syscall
    cmp rax, 0
    jl .err_epoll_ctl
    ret
.err_epoll:
    close_file [sockfd]
    print STD_ERR, EPOLL_ERR, EPOLL_ERR_LEN
    exit EXIT_FAILURE
.err_epoll_ctl:
    close_file [sockfd]
    close_file [epollfd]
    print STD_ERR, EPCTL_ERR, EPCTL_ERR_LEN
    exit EXIT_FAILURE