%ifndef FT_SHIELD_INC
%define FT_SHIELD_INC

%define SYS_WRITE 1
%define SYS_OPEN 2
%define SYS_CLOSE 3
%define SYS_ACCESS 21
%define SYS_SOCKET 41
%define SYS_ACCEPT 43
%define SYS_BIND 49
%define SYS_LISTEN 50
%define SYS_SETSOCKOPT 54
%define SYS_EXIT 60
%define SYS_FCNTL 72
%define SYS_FLOCK 73
%define SYS_GETUID 102
%define SYS_EPOLL_WAIT 232
%define SYS_EPOLL_CTL 233
%define SYS_EPOLL_CREATE1 291

%define STD_OUT 1
%define STD_ERR 2

%define O_CREAT 0100
%define LOCK_EX 1
%define F_OK 0

%define AF_INET 2
%define SOCK_STREAM 1
%define PORT 0x9210; 4242
%define MAX_USER 3
%define INADDR_ANY 0
%define SOL_SOCKET 1
%define SO_REUSEADDR 2

%define EXIT_SUCCESS 0
%define EXIT_FAILURE 1

%define MAX_EVENT 10
%define EPOLLIN 1
%define EPOLL_CTL_ADD 1
%define TIMEOUT -1

%define EPOLL_EVENT_SIZE 16

%macro exit 1
    mov rax, SYS_EXIT
    mov rdi, %1
    syscall
%endmacro

%macro print 3
    mov rax, SYS_WRITE
    mov rdi, %1
    mov rsi, %2
    mov rdx, %3
    syscall
%endmacro

%macro close_file 1
    mov rax, SYS_CLOSE
    mov rdi, %1
    syscall
%endmacro

%macro epoll_ctl 3
    mov rax, SYS_EPOLL_CTL
    mov rdi, %1
    mov rsi, %2
    mov rdx, %3
    lea r10, epoll
    syscall
%endmacro

struc sockaddr_in
    .sin_family resw 1
    .sin_port resw 1
    .sin_addr resd 1
    .sin_zero resb 8
endstruc

struc epoll_event
    .events resd 1
    .data resq 1
endstruc

section .bss
    sockfd resq 1
    epollfd resq 1
    epoll resb EPOLL_EVENT_SIZE
    events resb EPOLL_EVENT_SIZE*10
    usernb resb 1
%endif