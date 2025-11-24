%include "ft_shield.inc"

section .data
	EPOLL_ERR dd "Error while creating epoll\n"
	EPOLL_ERR_LEN equ $ - EPOLL_ERR
	EPCTL_ERR dd "Eor while adding server to epoll\n"
	EPCTL_ERR_LEN equ $ - EPCTL_ERR

section .text
	global init_epoll

init_epoll:
	mov dword[server_epoll + epoll_event.events], EPOLLIN
	mov rbx, rdi
	mov qword[server_epoll + epoll_event.data], rbx
.create_epoll:
	mov rax, SYS_EPOLL_CREATE1
	mov rdi, 0
	syscall
	cmp rax, 0
	jl .err_epoll
	mov r15, rax
.add_sockfd:
	epoll_ctl r15, EPOLL_CTL_ADD, rbx, [server_epoll]
	cmp rax, 0
	jl .err_epoll_ctl
	ret
.err_epoll:
	close_file rbx
	print STD_ERR, EPOLL_ERR, EPOLL_ERR_LEN
	exit EXIT_FAILURE
.err_epoll_ctl:
	close_file rbx
	close_file r15
	print STD_ERR, EPCTL_ERR, EPCTL_ERR_LEN
	exit EXIT_FAILURE